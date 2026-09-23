DROP FUNCTION IF EXISTS public.get_video_frame_info(in_video_id uuid,numeric);
CREATE OR REPLACE FUNCTION get_video_frame_info(
    p_video_id uuid,
    p_fps numeric DEFAULT 1  -- 默认fps=1，不传就用1
)
RETURNS TABLE (
    frame_count bigint,
    real_frame_count bigint,
    status text
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        FLOOR(b.video_duration * p_fps)::bigint AS frame_count,
        COUNT(a.id)::bigint AS real_frame_count,
        CASE
            WHEN COUNT(a.has_image ) =0  THEN 'Run'
            WHEN FLOOR(b.video_duration * p_fps) = COUNT(a.id) THEN 'Skip'
            WHEN FLOOR(b.video_duration * p_fps) <= COUNT(a.id) THEN 'Run'
            ELSE 'Run'
        END AS status
    FROM video_meta AS b
    LEFT JOIN video_frames AS a
        ON a.video_id = b."id"
    WHERE b."id" = p_video_id
    GROUP BY b."id", b.video_duration;
END;
$$;