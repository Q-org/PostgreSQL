-- 删掉所有名字叫 check_img_size_list 的重载版本
DROP FUNCTION IF EXISTS check_img_size_list(UUID);
DROP FUNCTION IF EXISTS check_img_size_list();
DROP FUNCTION IF EXISTS check_img_size_list(UUID, anyelement);

DROP FUNCTION IF EXISTS check_img_size_list(UUID);

CREATE OR REPLACE FUNCTION check_img_size_list(p_input_id UUID DEFAULT NULL)
RETURNS TABLE (
    seq bigint,
    id uuid,
    image_Path text
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
      ROW_NUMBER() OVER(ORDER BY f.video_id, f.pts_time) AS seq,
      f.id,
      regexp_replace(m.file_path,'\.\w+$','') || '/frame' || f.pts_time|| '.jpg' AS image_Path
    FROM
        video_frames AS f
        INNER JOIN video_meta AS m ON m.id = f.video_id
    WHERE
        f.img_size IS NULL
        AND COALESCE(p_input_id, f.video_id) = f.video_id
    ORDER BY f.video_id, f.pts_time;
END;
$$;
