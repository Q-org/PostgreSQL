-- 清理全部旧签名
DROP FUNCTION IF EXISTS process_video_review(uuid);
DROP FUNCTION IF EXISTS process_video_review(uuid, integer);
DROP FUNCTION IF EXISTS process_video_review_core(uuid, integer);

-- 双参数主函数：内置全部业务逻辑，去掉core
CREATE OR REPLACE FUNCTION process_video_review(
    p_video_id uuid,
    p_phash_threshold int
)
RETURNS TABLE (
    seq bigint,
    keep_idx bigint,
    keep_pts numeric,
    member_pts jsonb,
    member_count bigint,
    dedup_count bigint,
    pts_time numeric,
    has_image boolean,
    review_frame_img_path text
)
LANGUAGE plpgsql
VOLATILE
AS $$
BEGIN
    RETURN QUERY
WITH
    res AS (
        SELECT * FROM loop_frames(p_video_id, p_phash_threshold)
    ),
    res_distinct AS (
        -- 按frame_pts去重，同一个pts图片只保留一条
        SELECT DISTINCT ON (frame_pts)
            frame_pts,
            similar_pts,
            distance
        FROM res
        ORDER BY frame_pts
    ),
    group_range AS (
        SELECT
            frame_pts AS base_pts,
            MIN(LEAST(frame_pts, similar_pts)) AS clip_start_pts,
            MAX(GREATEST(frame_pts, similar_pts)) AS clip_end_pts,
            jsonb_agg(DISTINCT similar_pts ORDER BY similar_pts) AS similar_member_pts,
            COUNT(DISTINCT similar_pts)::bigint AS member_count
        FROM res_distinct
        WHERE similar_pts IS NOT NULL
        GROUP BY frame_pts
        UNION ALL
        SELECT
            frame_pts AS base_pts,
            frame_pts AS clip_start_pts,
            frame_pts AS clip_end_pts,
            '[]'::jsonb AS similar_member_pts,
            0::bigint AS member_count
        FROM res_distinct
        WHERE similar_pts IS NULL
    )
SELECT
    ROW_NUMBER() OVER (ORDER BY gr.clip_start_pts)::bigint AS seq,
    t_base.idx::bigint AS keep_idx,
    gr.base_pts AS keep_pts,
    (jsonb_build_array(gr.base_pts) || gr.similar_member_pts) AS member_pts,
    gr.member_count,
    (gr.member_count + 1)::bigint AS dedup_count,
    t_base.pts_time,
    t_base.has_image,
    REGEXP_REPLACE(vm.file_path, '\.[^.]+$', '') || '/frame' || t_base.pts_time || '.jpg' AS review_frame_img_path
FROM group_range gr
JOIN video_frames t_base
  ON t_base.video_id = p_video_id
  AND ABS(t_base.pts_time - gr.base_pts) < 0.001
JOIN video_frames t_start
  ON t_start.video_id = p_video_id
  AND ABS(t_start.pts_time - gr.clip_start_pts) < 0.001
JOIN video_frames t_end
  ON t_end.video_id = p_video_id
  AND ABS(t_end.pts_time - gr.clip_end_pts) < 0.001
JOIN video_meta vm
    ON vm.id = p_video_id
ORDER BY gr.clip_start_pts;
END;
$$;

-- 单参数包装函数：默认阈值12，直接调用上面双参数版本
CREATE OR REPLACE FUNCTION process_video_review(p_video_id uuid)
RETURNS TABLE (
    seq bigint,
    keep_idx bigint,
    keep_pts numeric,
    member_pts jsonb,
    member_count bigint,
    dedup_count bigint,
    pts_time numeric,
    has_image boolean,
    review_frame_img_path text
)
LANGUAGE plpgsql
VOLATILE
AS $$
BEGIN
    RETURN QUERY SELECT * FROM process_video_review(p_video_id, 12);
END;
$$;
