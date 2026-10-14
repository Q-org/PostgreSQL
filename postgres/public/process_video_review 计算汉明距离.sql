WITH CONST AS (
SELECT 
'cbc9b37c-5f18-4089-8381-a04852ab3d86'::UUID AS VIDEO_ID
,replace('E:/26.5\（新）被抛弃的兔骑士与他的新伴侣：大祭司/1-80.mp4','\','/') AS P_FILE_PATH 
, (1.0 / 0.2)::numeric AS step_sec
, 0.001::numeric AS pts_epsilon
, 10 AS phash_thresh -- 你原来缺少这个！bit_count阈值，必须补上
),
frames AS (
    SELECT
        f.pts_time,
        f.id,
        f.phash_bits AS phash_bits,
        f.img_size,
        f.has_image
    FROM video_frames f
    CROSS JOIN const c
    WHERE f.video_id = c.video_id
      AND f.phash_bits IS NOT NULL
      AND ABS(mod(f.pts_time, c.step_sec)) < c.pts_epsilon
),
result AS (
    SELECT
        f1.pts_time AS keep_pts,
        COALESCE(t.b_pts_list, '[]'::jsonb) AS b_pts_list,
        COALESCE(t.dist_list, '[]'::jsonb) AS dist_list
    FROM frames f1
    CROSS JOIN const c
    LEFT JOIN LATERAL (
        SELECT
            jsonb_agg(f2.pts_time ORDER BY f2.pts_time) AS b_pts_list,
            jsonb_agg(f2.phash_bits) AS dist_list
        FROM frames f2
        WHERE f2.pts_time > f1.pts_time
          AND bit_count(f1.phash_bits # f2.phash_bits) < c.phash_thresh
    ) t ON true
),
expanded AS (
    SELECT
        r.keep_pts AS frame_pts,
        jsonb_array_elements_text(r.b_pts_list)::numeric AS similar_pts
    FROM result r
),
group_range AS (
    SELECT
        e.frame_pts AS base_pts,
        MIN(LEAST(e.frame_pts, e.similar_pts)) AS clip_start_pts,
        MAX(GREATEST(e.frame_pts, e.similar_pts)) AS clip_end_pts,
        jsonb_agg(DISTINCT e.similar_pts ORDER BY e.similar_pts) AS similar_member_pts,
        COUNT(DISTINCT e.similar_pts)::bigint AS member_cnt
    FROM expanded e
    GROUP BY e.frame_pts
    UNION ALL
    SELECT
        r.keep_pts AS base_pts,
        r.keep_pts AS clip_start_pts,
        r.keep_pts AS clip_end_pts,
        '[]'::jsonb AS similar_member_pts,
        0::bigint AS member_cnt
    FROM result r
    WHERE jsonb_array_length(r.b_pts_list) = 0
),
raw_result AS (
    SELECT
        gr.base_pts AS keep_pts,
        tb.id AS keep_idx,
        (jsonb_build_array(gr.base_pts) || gr.similar_member_pts) AS member_pts,
        gr.member_cnt AS member_count,
        (gr.member_cnt + 1)::bigint AS dedup_count,
        tb.pts_time,
        tb.has_image,
        tb.img_size,
        REGEXP_REPLACE(vm.file_path, '\.[^.]+$', '') || '/frame' || tb.pts_time || '.jpg' AS review_frame_img_path
    FROM group_range gr
    CROSS JOIN const c
    JOIN video_frames tb
        ON tb.video_id = c.video_id
        AND ABS(tb.pts_time - gr.base_pts) < c.pts_epsilon
    JOIN video_meta vm
        ON vm.id = c.video_id
),
filter_result AS (
    SELECT
        rr.*
    FROM raw_result rr
    WHERE NOT EXISTS (
        SELECT 1
        FROM raw_result prev
        WHERE prev.keep_pts < rr.keep_pts
          AND prev.member_pts @> jsonb_build_array(rr.keep_pts)
    )
)
SELECT
    ROW_NUMBER() OVER(ORDER BY fr.keep_pts)::bigint AS seq,
    fr.keep_idx,
    fr.keep_pts,
    fr.member_pts,
    fr.member_count,
    fr.dedup_count,
    fr.pts_time,
    fr.has_image,
    fr.img_size,
    fr.review_frame_img_path
FROM filter_result fr
ORDER BY fr.keep_pts;




select * FROM public.process_video_review('cbc9b37c-5f18-4089-8381-a04852ab3d86'::uuid);

