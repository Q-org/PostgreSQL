CREATE OR REPLACE FUNCTION fn_get_video_risk_frames(p_video_id uuid)
RETURNS TABLE (
    video_id uuid,
    pts_time numeric,
    phash_hex text,
    risk_codes text[],
    risk_names text[],
    risk_descriptions text[],
    max_risk_level integer,
    "imagePath" text,
    file_path text,
    review_frame_img_path text
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        f.video_id,
        A.pts_time,
        f.phash_hex,
        ARRAY_AGG(rr.risk_code ORDER BY rr.risk_code) AS risk_codes,
        ARRAY_AGG(rr.risk_name ORDER BY rr.risk_code) AS risk_names,
        ARRAY_AGG(rr.description ORDER BY rr.risk_code) AS risk_descriptions,
        MAX(rr.risk_level) AS max_risk_level,
        f."imagePath",
        m.file_path,
        REGEXP_REPLACE(
            m.file_path,
            '\.[^.]+$',
            ''
        )
        || '/frame'
        || A.pts_time
        || '.jpg' AS review_frame_img_path
    FROM
        video_meta AS m
        INNER JOIN video_frames AS f
            ON m.id = f.video_id
        INNER JOIN analysis_result AS A
            ON A.video_id = f.video_id
            AND A.pts_time = f.pts_time
        INNER JOIN review_risk AS rr
            ON A.risk_id = rr.id
            AND rr.risk_level > 1
    WHERE
        m.id = p_video_id
    GROUP BY
        f.video_id,
        A.pts_time,
        f.phash_hex,
        f."imagePath",
        m.file_path
    ORDER BY
        A.pts_time ASC;
END;
$$;
