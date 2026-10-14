WITH const AS (
    SELECT
        1.0::numeric AS base_fps,
        0.2::numeric AS fps,
        (
            1.0 / 0.2
            - 1.0 / 1.0
        ) AS step
)
,frames AS (
    SELECT
        a.video_id,
        trim_scale(a.pts_time) AS anchor_pts
        ,trim_scale(p.pts_time) AS need_pts
        ,rr.*
    FROM analysis_result AS a

    CROSS JOIN const AS c

    INNER JOIN review_risk AS rr
        ON a.risk_id = rr.id
       AND rr.risk_level > 1

    CROSS JOIN LATERAL generate_series(
        a.pts_time - c.step,
        a.pts_time + c.step,
        1.0::numeric
    ) AS p(pts_time)

    WHERE a.video_id =
        '3ac8914f-4ece-4210-a2e2-1790f2714fdc'

      AND p.pts_time <> a.pts_time

      AND NOT EXISTS (
          SELECT 1
          FROM video_frames AS vf
          WHERE vf.video_id = a.video_id
            AND vf.pts_time BETWEEN
                p.pts_time - 0.00001
                AND
                p.pts_time + 0.00001
      )
)
,missing_pts AS (
    SELECT
        video_id,
        count(DISTINCT need_pts) AS num,
        JSONB_AGG(
            DISTINCT  need_pts
            ORDER BY need_pts
        ) AS missing_pts_arr
    FROM frames
    GROUP BY video_id
)
SELECT
    m.id,
    m.video_fps,
    m.duration,
    c.base_fps,
    c.fps,
    f.num,
    c.step,
    m.file_path,
    f.missing_pts_arr  
FROM missing_pts AS f
CROSS JOIN const AS c
INNER JOIN video_meta AS m
    ON f.video_id = m.id
    ;

SELECT * FROM public.get_missing_frames('3ac8914f-4ece-4210-a2e2-1790f2714fdc')