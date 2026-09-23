WITH params AS (
   SELECT 8 AS th_hamming
),
matched AS (
    SELECT
        f.idx,
        CASE WHEN f.idx = 0 THEN NULL::bigint
             ELSE (
                SELECT MIN(e.idx) FROM video_frames e
                WHERE e.video_id = f.video_id
                  AND e.idx < f.idx
                  AND bit_count(e.phash_bits # f.phash_bits) <= (SELECT th_hamming FROM params)
             )
        END AS anchor_idx
    FROM video_frames f
    WHERE f.video_id = 'd005c9e7-abf2-4bb4-bbff-37189088013e'
),
clusters AS (
    SELECT
        COALESCE(anchor_idx, idx) AS keep_idx,
        jsonb_agg(idx ORDER BY idx) AS member_idxs,  -- ← jsonb_agg
        COUNT(*) AS member_count
    FROM matched
    GROUP BY COALESCE(anchor_idx, idx)
)
SELECT
    ROW_NUMBER() OVER (ORDER BY c.keep_idx)::bigint AS seq,
    c.keep_idx,
    f.pts_time,
    f.has_image,
    c.member_idxs,                 -- jsonb
    c.member_count,
    (c.member_count - 1)::bigint AS dedup_count,
    REGEXP_REPLACE(vm.file_path, '\.[^.]+$', '')
        || '/frame_snap/frame_' || c.keep_idx || '.jpg' AS review_frame_img_path
FROM clusters c
JOIN video_frames f ON f.video_id = 'd005c9e7-abf2-4bb4-bbff-37189088013e' AND f.idx = c.keep_idx
JOIN video_meta vm  ON vm.id = 'd005c9e7-abf2-4bb4-bbff-37189088013e'
ORDER BY c.keep_idx;


select *  FROM  public.process_video_review('d005c9e7-abf2-4bb4-bbff-37189088013e')