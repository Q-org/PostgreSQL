WITH candidates AS (
    SELECT
        a.video_id,
        a.idx,
        a.pts_time,
        a.phash_hex,
        MIN(bit_count(a.phash_bits # b.phash_bits)) AS min_hamming,
        COUNT(*) AS match_count
    FROM video_frames a
    JOIN video_frames b
        ON b.video_id = a.video_id
       AND b.idx BETWEEN a.idx + 2 AND a.idx + 10
    WHERE a.video_id = 'ed07bc77-852f-475b-97cc-5d0261f25318'
      AND bit_count(a.phash_bits # b.phash_bits) <= 12
    GROUP BY
        a.video_id,
        a.id,
        a.idx,
        a.pts_time,
        a.phash_hex
),

marked AS (
    SELECT
        *,
        CASE
            WHEN LAG(idx) OVER (ORDER BY idx) IS NULL
              OR idx - LAG(idx) OVER (ORDER BY idx) > 10
            THEN 1
            ELSE 0
        END AS new_group
    FROM candidates
),

grouped AS (
    SELECT
        *,
        SUM(new_group) OVER (ORDER BY idx) AS group_id
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

    '/frame_snap/frame_' || review_idx || '.jpg' AS img_path

FROM segments
ORDER BY start_idx;