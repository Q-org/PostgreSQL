DROP FUNCTION IF EXISTS public.get_video_frame_info(uuid,numeric);
CREATE OR REPLACE FUNCTION public.get_video_frame_info(
    p_video_id uuid,
    p_fps numeric DEFAULT 1
)
RETURNS TABLE (
    frame_count bigint,
    real_frame_count bigint,
    status text
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_duration numeric;
BEGIN
    SELECT b.duration INTO v_duration
    FROM video_meta b
    WHERE b.id = p_video_id;

    --元数据不存在
    IF NOT FOUND THEN
        RETURN QUERY SELECT 0::bigint, 0::bigint, 'NotFound'::text;
        RETURN;
    END IF;

    --元数据一定存在，子查询统计帧，不受video_frames空表影响
    RETURN QUERY
    SELECT
        FLOOR(COALESCE(v_duration, 0) * p_fps)::bigint AS frame_count,
        COALESCE(stat.real_frame_count, 0)::bigint AS real_frame_count,
        CASE
            WHEN COALESCE(stat.has_any_image, false) = false THEN 'Run'
            WHEN FLOOR(COALESCE(v_duration,0)*p_fps) = COALESCE(stat.real_frame_count, 0) THEN 'Skip'
            ELSE 'Run'
        END AS status
    FROM (
        SELECT
            COUNT(CASE WHEN pts_time IS NOT NULL THEN id END) AS real_frame_count,
            BOOL_OR(has_image = true) AS has_any_image
        FROM video_frames
        WHERE video_id = p_video_id
    ) stat;

END;
$$;

