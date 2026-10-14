DROP FUNCTION IF EXISTS get_review_point(uuid);
DROP FUNCTION IF EXISTS get_review_point(uuid,numeric);
CREATE OR REPLACE FUNCTION get_review_point(
    p_video_id uuid,
    p_sparsity numeric DEFAULT 1.0
)
RETURNS TABLE (
    seq bigint,
    anchor_id uuid,
    video_id uuid,
    anchor_pts numeric,
    pts_time numeric,
    image_path text
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    WITH const AS (
        SELECT
            regexp_replace(m.file_name, '\.[^.]+$', '') AS file_name,
            m.id AS video_id,
            m.file_path,
            m.duration,
            m.video_fps,
            regexp_replace(m.file_path, '\.[^.]+$', '') || '/frame' AS base_path,
            p_sparsity AS sparsity,
            0.2::numeric AS sparsity_of_sampling,
            (
                1.0 / 0.2 - 1.0 / 1.0
            )::numeric AS step
        FROM video_meta m
        WHERE m.id = p_video_id
    ),
    anchors AS (
        SELECT
             a.id AS id,
            a.video_id,
            a.pts_time AS anchor_pts
        FROM analysis_result as a
        CROSS JOIN const c
        INNER JOIN review_risk rr
            ON rr.id = a.risk_id
           AND rr.risk_level > 1
        WHERE a.video_id = c.video_id
        GROUP BY a.video_id,a.id,a.pts_time
    ),
    candidates AS (
        SELECT
            a.id AS anchor_id,
            a.video_id,
            a.anchor_pts,
            p.pts_time
        FROM anchors a
        CROSS JOIN const c
        CROSS JOIN LATERAL generate_series(
            a.anchor_pts - c.step,
            a.anchor_pts + c.step,
            c.sparsity
        ) AS p(pts_time)
        WHERE p.pts_time >= 0
    ),
    dedup AS (
        SELECT DISTINCT ON (
            c.video_id,
            round(c.pts_time)
        )
            c.anchor_id,
            c.video_id,
            c.anchor_pts,
            trim_scale(c.pts_time) AS pts_time,
            b.base_path|| trim_scale(c.pts_time) ||'.jpg' AS image_path
        FROM candidates c
        CROSS JOIN const b
        ORDER BY
            c.video_id,
            round(c.pts_time),
            abs(c.pts_time - c.anchor_pts),
            c.anchor_pts
    )
    SELECT
        ROW_NUMBER() OVER (ORDER BY c.pts_time) AS seq,
        c.anchor_id,
        c.video_id,
        c.anchor_pts,
        c.pts_time,
        c.image_path
    FROM dedup c;
END;
$$;
