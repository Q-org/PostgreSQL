WITH params AS (
    SELECT
        5 AS th_hamming,        -- 汉明距离阈值
        2 AS frame_offset_start, -- 从后面第几帧开始比对
        10 AS frame_offset_end, -- 向后最多比对多少帧
        10 AS gap_threshold     -- 片段合并间隙阈值
),
candidates AS (
    SELECT
        a.video_id,
        a.idx,
        a.pts_time,
        a.phash_hex,
        MIN(bit_count(a.phash_bits # b.phash_bits)) AS min_hamming,
        COUNT(*) AS match_count
    FROM video_frames a
    CROSS JOIN params p
    JOIN video_frames b
        ON b.video_id = a.video_id
       AND b.idx BETWEEN a.idx + p.frame_offset_start AND a.idx + p.frame_offset_end
    WHERE a.video_id = 'd005c9e7-abf2-4bb4-bbff-37189088013e'
      AND bit_count(a.phash_bits # b.phash_bits) <= p.th_hamming
    GROUP BY
        a.video_id,
        a.id,
        a.idx,
        a.pts_time,
        a.phash_hex,
        p.th_hamming, p.frame_offset_start, p.frame_offset_end, p.gap_threshold
),
marked AS (
    SELECT
        c.*,
        p.*,
        CASE
            WHEN LAG(idx) OVER (ORDER BY idx) IS NULL
              OR idx - LAG(idx) OVER (ORDER BY idx) > p.gap_threshold
            THEN 1
            ELSE 0
        END AS new_group
    FROM candidates c, params p
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
    ROW_NUMBER() OVER (ORDER BY s.start_idx) AS row_no,
    s.video_id,
    s.group_id,
    s.start_idx,
    s.end_idx,
    s.start_pts,
    s.end_pts,
    s.end_pts - s.start_pts AS duration,
    s.min_hamming,
    s.max_match_count,
    s.review_idx,
    REGEXP_REPLACE(vm.file_path,'[\\]|\.[^.]+$','/' )|| 'frame_' || s.review_idx || '.jpg' AS img_path
FROM segments s
left JOIN video_meta vm
  ON vm.id = s.video_id
ORDER BY s.start_idx;



select *  FROM  public.process_video_review('d005c9e7-abf2-4bb4-bbff-37189088013e')