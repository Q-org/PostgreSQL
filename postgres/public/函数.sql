CREATE OR REPLACE FUNCTION public.process_video_review(in_video_id uuid)
RETURNS TABLE (
    row_no bigint,
    video_id uuid,
    group_id bigint,
    start_idx bigint,
    end_idx bigint,
    start_pts double precision,
    end_pts double precision,
    duration double precision,
    min_hamming int,
    max_match_count bigint,
    review_idx bigint,
    img_path text,
    risk_level text
)
LANGUAGE plpgsql
STABLE
COST 100
ROWS 10000
AS $BODY$
BEGIN
RETURN QUERY
WITH candidates AS (
    SELECT
        f1.video_id,
        f1.id,
        f1.idx,
        f1.pts_time,
        f1.phash_hex,
        (
            SELECT MIN(bit_count(f1.phash_bits # f2.phash_bits))
            FROM video_frames f2
            WHERE f2.video_id = f1.video_id
              AND f2.idx BETWEEN f1.idx + 2 AND f1.idx + 10
        ) AS min_hamming,
        (
            SELECT COUNT(*)
            FROM video_frames f2
            WHERE f2.video_id = f1.video_id
              AND f2.idx BETWEEN f1.idx + 2 AND f1.idx + 10
              AND bit_count(f1.phash_bits # f2.phash_bits) <= 12
        ) AS match_count
    FROM video_frames f1
    WHERE f1.video_id = in_video_id
),
filtered AS (
    SELECT * FROM candidates WHERE min_hamming <= 12
),
marked AS (
    SELECT
        *,
        CASE
            WHEN LAG(idx) OVER (ORDER BY idx) IS NULL OR idx - LAG(idx) OVER (ORDER BY idx) > 10
            THEN 1 ELSE 0
        END AS new_group
    FROM filtered
),
grouped AS (
    SELECT *, SUM(new_group) OVER (ORDER BY idx) AS group_id
    FROM marked
),
segments AS (
    SELECT
        video_id,
        group_id,
        MIN(idx) AS start_idx,
        MAX(idx) AS end_idx,
        MIN(pts_time) AS start_pts,
        MAX(pts_time) AS end_pts,
        MIN(min_hamming) AS min_hamming,
        MAX(match_count) AS max_match_count,
        MIN(idx) + ((MAX(idx) - MIN(idx)) / 2) AS review_idx
    FROM grouped
    GROUP BY video_id, group_id
)
SELECT
    ROW_NUMBER() OVER (ORDER BY start_idx) AS row_no,
    video_id,
    group_id,
    start_idx,
    end_idx,
    start_pts,
    end_pts,
    end_pts - start_pts AS duration,
    min_hamming,
    max_match_count,
    review_idx,
    '/frame_snap/frame_' || review_idx || '.jpg' AS img_path,
    CASE WHEN min_hamming <=5 THEN '高风险：静态画面，重点审核' ELSE '中风险：画面变化小，建议审核' END AS risk_level
FROM segments
ORDER BY start_idx;
END;
$BODY$;
