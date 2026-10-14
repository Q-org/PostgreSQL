DROP FUNCTION IF EXISTS get_segments_blur(uuid);
CREATE OR REPLACE FUNCTION get_segments_blur(p_video_id uuid)
RETURNS TABLE (
    video_id uuid,
    video_path text,
    duration numeric,
    video_codec text,
    video_fps numeric,
    start_pts double precision,
    end_pts double precision,
    risk_ids jsonb,
    risk_levels jsonb
)
AS $$
BEGIN
    RETURN QUERY
WITH meta AS (
    SELECT
        m.id AS video_id,
        m.file_path AS video_path,
        m.duration,
        m.video_codec,
        m.video_fps
    FROM video_meta AS m
    WHERE id = p_video_id
),
src AS (
    SELECT
        a.video_id,
        a.pts_time,
        a.risk_id,
        r.risk_level
    FROM analysis_result AS a
    CROSS JOIN meta
    INNER JOIN review_risk AS r ON a.risk_id = r.id
    WHERE
        a.video_id = meta.video_id
        AND r.risk_level > 1
),
ordered AS (
    SELECT
        *,
        LAG(pts_time) OVER(PARTITION BY src.video_id ORDER BY pts_time) AS prev_pts
    FROM src
),
island_mark AS (
    SELECT
        *,
        CASE
            WHEN prev_pts IS NULL OR pts_time - prev_pts >= 2
            THEN 1
            ELSE 0
        END AS is_new_group
    FROM ordered
),
island_id AS (
    SELECT
        *,
        -- 修复歧义：显式指定表别名 island_mark
        SUM(is_new_group) OVER(PARTITION BY island_mark.video_id ORDER BY pts_time) AS group_id
    FROM island_mark
),
segms AS (
    SELECT
        a.video_id,
        MIN(pts_time)::double precision AS start_pts,
        MAX(pts_time)::double precision AS end_pts,
        JSONB_AGG(DISTINCT risk_id) AS risk_ids,
        JSONB_AGG(DISTINCT risk_level) AS risk_levels
    FROM island_id AS a
    GROUP BY a.video_id, group_id
    ORDER BY start_pts ASC
)
SELECT
    meta.video_id,
    meta.video_path,
    meta.duration,
    meta.video_codec,
    meta.video_fps,
    segms.start_pts,
    segms.end_pts,
    segms.risk_ids,
    segms.risk_levels
FROM segms
CROSS JOIN meta;
END;
$$ LANGUAGE plpgsql STABLE;
