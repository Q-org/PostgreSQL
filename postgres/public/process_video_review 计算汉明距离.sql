WITH res AS (
    SELECT * FROM loop_frames('c2f24707-25bc-4936-b485-928795f66814'::uuid,12)
),
group_range AS (
    SELECT
        frame_pts AS base_pts,
        MIN(LEAST(frame_pts, similar_pts)) AS clip_start_pts,
        MAX(GREATEST(frame_pts, similar_pts)) AS clip_end_pts,
        jsonb_agg(DISTINCT similar_pts ORDER BY similar_pts) AS similar_member_pts,
        COUNT(DISTINCT similar_pts)::bigint AS member_count
    FROM res
    WHERE similar_pts IS NOT NULL
    GROUP BY frame_pts

    UNION ALL

    SELECT
        frame_pts AS base_pts,
        frame_pts AS clip_start_pts,
        frame_pts AS clip_end_pts,
        '[]'::jsonb AS similar_member_pts,
        0::bigint AS member_count
    FROM res
    WHERE similar_pts IS NULL
)
SELECT
    ROW_NUMBER() OVER (ORDER BY gr.clip_start_pts) AS seq,
    gr.base_pts AS keep_pts,
    t_base.idx AS keep_idx, -- 仅用于图片文件名输出，业务不用
    -- base_pts合并进数组成完整组pts集合
    (jsonb_build_array(gr.base_pts) || gr.similar_member_pts) AS member_pts,
    gr.member_count,
    (gr.member_count + 1)::bigint AS dedup_count,
    t_base.pts_time,
    t_base.has_image,
    REGEXP_REPLACE(vm.file_path, '\.[^.]+$', '') || '/frame' || t_base.pts_time || '.jpg' AS review_frame_img_path
FROM group_range gr
JOIN video_frames t_base
  ON t_base.video_id = 'c2f24707-25bc-4936-b485-928795f66814'::uuid
  AND t_base.pts_time = gr.base_pts
JOIN video_frames t_start
  ON t_start.video_id = 'c2f24707-25bc-4936-b485-928795f66814'::uuid
  AND t_start.pts_time = gr.clip_start_pts
JOIN video_frames t_end
  ON t_end.video_id = 'c2f24707-25bc-4936-b485-928795f66814'::uuid
  AND t_end.pts_time = gr.clip_end_pts
JOIN video_meta vm
    ON vm.id = 'c2f24707-25bc-4936-b485-928795f66814'::uuid
ORDER BY gr.clip_start_pts;



select * FROM public.process_video_review('c2f24707-25bc-4936-b485-928795f66814'::uuid);