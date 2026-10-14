WITH const AS (
    SELECT
        1.0::numeric AS base_fps,
        0.2::numeric AS fps,
        (
            1.0 / 0.2
            - 1.0 / 1.0
        ) AS step
)
-- frames AS (
      SELECT
          a.video_id,
          a.pts_time AS anchor_pts,
          fa.phash_hex AS anchor_phash,
          round(p.pts_time) AS need_pts,
          f.pts_time,
          f.phash_hex,
          CASE
                WHEN fa.phash_hex IS NULL OR f.phash_hex IS NULL THEN NULL
                WHEN LENGTH(fa.phash_hex) <> 16 OR LENGTH(f.phash_hex) <> 16 THEN NULL
                WHEN fa.phash_hex !~ '^[0-9a-fA-F]{16}$' OR f.phash_hex !~ '^[0-9a-fA-F]{16}$' THEN NULL
              ELSE BIT_COUNT( (('x' || fa.phash_hex)::bit(64)) # (('x' || f.phash_hex)::bit(64)) )
          END AS hamming_dist
      FROM analysis_result AS a
      CROSS JOIN const AS c
      INNER JOIN review_risk AS rr
          ON a.risk_id = rr.id
         AND rr.risk_level > 1

      LEFT JOIN video_frames fa
          ON fa.video_id = a.video_id
          AND fa.pts_time >= a.pts_time - 1e-6
          AND fa.pts_time <= a.pts_time + 1e-6

      CROSS JOIN LATERAL generate_series(
          a.pts_time - c.step,
          a.pts_time + c.step,
          1.0::numeric
      ) AS p(pts_time)

      LEFT JOIN video_frames f
          ON f.video_id = a.video_id
          AND f.pts_time >= p.pts_time - 1e-6
          AND f.pts_time <= p.pts_time + 1e-6

    WHERE a.video_id =
        '4e828a08-9724-4a85-b551-37ba502750b7'
--     AND f.video_id IS NULL;
--       AND p.pts_time <> a.pts_time

--       AND NOT EXISTS (
--           SELECT 1
--           FROM video_frames AS vf
--           WHERE vf.video_id = a.video_id
--             AND vf.pts_time BETWEEN
--                 p.pts_time - 0.00001
--                 AND
--                 p.pts_time + 0.00001
--       )
-- ),
-- 
-- missing_pts AS (
--     SELECT
--         video_id,
--         count(DISTINCT need_pts) AS num,
--         JSONB_AGG(
--             DISTINCT need_pts
--             ORDER BY need_pts
--         ) AS missing_pts_arr
--     FROM frames
--     GROUP BY video_id
-- )
-- 
-- SELECT
--     m.id,
--     m.video_fps,
--     m.duration,
--     c.base_fps,
--     c.fps,
--     f.num,
--     c.step,
--     m.file_path,
--     f.missing_pts_arr
-- FROM missing_pts AS f
-- CROSS JOIN const AS c
-- INNER JOIN video_meta AS m
--     ON f.video_id = m.id;
-- 
-- SELECT * FROM public.get_missing_frame_pts('3b06d824-d067-455c-8395-9948d8a59278')