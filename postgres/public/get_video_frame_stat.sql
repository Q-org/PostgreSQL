-- 删除旧函数，解决返回类型冲突
DROP FUNCTION IF EXISTS get_video_frame_stat(uuid, numeric);

CREATE OR REPLACE FUNCTION get_video_frame_stat(p_video_id uuid, p_sample_fps numeric = 0.2)
RETURNS TABLE (
    video_id uuid,
    duration numeric,
    fps numeric,
    base numeric,
    step numeric,
    pts_arr numeric[],
    existing_pts_arr numeric[],
    missing_pts_arr numeric[],
    total_sample_points bigint,
    matched_frames bigint,
    missing_frames bigint,
    status text
)
LANGUAGE sql
AS $$
WITH const AS (
    SELECT
        p_sample_fps::numeric AS fps,
        0::numeric AS base
),
video_info AS (
    SELECT
        m.id AS video_id,
        m.duration::numeric AS duration,
        c.fps,
        c.base,
        ROUND(1.0 / c.fps, 6) AS step
    FROM video_meta AS m
    CROSS JOIN const AS c
    WHERE m.id = p_video_id
),
expected_pts AS (
    SELECT
        v.video_id,
        v.duration,
        v.fps,
        v.base,
        v.step,
        gs.n,
        ROUND(
            v.base + gs.n * v.step,
            6
        ) AS pts
    FROM video_info AS v
    CROSS JOIN LATERAL generate_series(
        0,
        FLOOR(
            (v.duration - v.base) / v.step
        )::bigint
    ) AS gs(n)
    WHERE v.step > 0
),
frems AS (
    SELECT
        e.video_id,
        e.duration,
        e.fps,
        e.base,
        e.step,
        e.n,
        e.pts,
        f.pts_time,
        f.id
    FROM expected_pts AS e
    LEFT JOIN video_frames AS f
        ON f.video_id = e.video_id
       AND ABS(f.pts_time - e.pts) <= 0.000001
),
stat AS (
    SELECT
        video_id,
        duration,
        fps,
        base,
        step,
        ARRAY_AGG(pts ORDER BY pts) AS pts_arr,
        ARRAY_AGG(pts ORDER BY pts) FILTER (WHERE id IS NOT NULL) AS existing_pts_arr,
        ARRAY_AGG(pts ORDER BY pts) FILTER (WHERE id IS NULL) AS missing_pts_arr,
        COUNT(*) AS total_sample_points,
        COUNT(*) FILTER (WHERE id IS NOT NULL) AS matched_frames,
        COUNT(*) FILTER (WHERE id IS NULL) AS missing_frames
    FROM frems
    GROUP BY
        video_id,
        duration,
        fps,
        base,
        step
)
SELECT
    stat.video_id,
    stat.duration,
    stat.fps,
    stat.base,
    stat.step,
    stat.pts_arr,
    stat.existing_pts_arr,
    stat.missing_pts_arr,
    stat.total_sample_points,
    stat.matched_frames,
    stat.missing_frames,
    CASE
        WHEN stat.missing_frames = 0 THEN 'skip'
        ELSE 'run'
    END AS status
FROM stat;
$$;
