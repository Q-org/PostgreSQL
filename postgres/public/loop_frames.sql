DROP FUNCTION IF EXISTS loop_frames(uuid);
DROP FUNCTION IF EXISTS loop_frames(uuid, integer);
DROP FUNCTION IF EXISTS loop_frames(uuid, integer, numeric);

CREATE OR REPLACE FUNCTION loop_frames(
    p_video_id uuid,
    p_distance int DEFAULT 8,
    p_pts_gap numeric DEFAULT NULL
)
RETURNS TABLE (
    a_pts numeric,
    b_pts_list jsonb,
    dist_list jsonb
)
LANGUAGE sql
AS $$
    WITH frames AS (
        SELECT
            f.id,
            f.pts_time,
            f.phash_bits
        FROM video_frames f
        WHERE f.video_id = p_video_id
          AND f.fps <= 0.2
          AND f.phash_bits IS NOT NULL
    )
    SELECT
        f1.pts_time AS a_pts,

        COALESCE(
            jsonb_agg(
                f2.pts_time
                ORDER BY f2.pts_time
            ) FILTER (WHERE f2.id IS NOT NULL),
            '[]'::jsonb
        ) AS b_pts_list,

        COALESCE(
            jsonb_agg(
                bit_count(f1.phash_bits # f2.phash_bits)
                ORDER BY f2.pts_time
            ) FILTER (WHERE f2.id IS NOT NULL),
            '[]'::jsonb
        ) AS dist_list

    FROM frames f1

    LEFT JOIN frames f2
      ON f1.pts_time < f2.pts_time

     AND bit_count(
            f1.phash_bits # f2.phash_bits
         ) < p_distance

     AND (
            p_pts_gap IS NULL
            OR f2.pts_time <= f1.pts_time + p_pts_gap
         )

    GROUP BY f1.pts_time
    ORDER BY f1.pts_time;
$$;