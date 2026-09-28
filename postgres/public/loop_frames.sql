DROP FUNCTION IF EXISTS loop_frames(uuid);
DROP FUNCTION IF EXISTS loop_frames(uuid,integer);
DROP FUNCTION IF EXISTS loop_frames(uuid,integer,numeric);


CREATE OR REPLACE FUNCTION loop_frames(
    p_video_id uuid,
    p_distance int DEFAULT 8,
    p_pts_gap numeric DEFAULT NULL  -- NULL=全对比；单位秒，仅向后对比
)
RETURNS TABLE (
    frame_pts numeric,
    similar_pts numeric,
    distance int
)
AS $$
DECLARE
    rec record;
    sim record;
    v_has_similar boolean;
    v_old_dist int;
BEGIN
    SELECT MAX(last_distance) INTO v_old_dist
    FROM loop_frames_result
    WHERE video_id = p_video_id;

    -- 缓存命中直接返回
    IF v_old_dist IS NOT NULL AND v_old_dist = p_distance THEN
        RETURN QUERY
        SELECT r.frame_pts, r.similar_pts, r.distance
        FROM loop_frames_result r
        WHERE r.video_id = p_video_id
        ORDER BY r.frame_pts, r.distance, r.similar_pts;
        RETURN;
    END IF;

    DELETE FROM loop_frames_result WHERE video_id = p_video_id;

    CREATE TEMP TABLE IF NOT EXISTS tmp_group_member
    (
        pts numeric PRIMARY KEY
    ) ON COMMIT DROP;

    FOR rec IN
        SELECT vf.pts_time, vf.phash_bits
        FROM video_frames vf
        WHERE vf.video_id = p_video_id AND vf.phash_bits IS NOT NULL
        ORDER BY vf.pts_time
    LOOP
        -- ⚠️ 浮点pts不能直接等于，epsilon 1ms容差判断是否已经入组
        IF EXISTS (
            SELECT 1 FROM tmp_group_member m
            WHERE ABS(m.pts - rec.pts_time) < 0.001
        ) THEN
            CONTINUE;
        END IF;

        v_has_similar := false;

        FOR sim IN
            SELECT
                vf.pts_time,
                bit_count(rec.phash_bits # vf.phash_bits) AS dist
            FROM video_frames vf
            WHERE vf.video_id = p_video_id
              AND vf.phash_bits IS NOT NULL
              AND vf.pts_time > rec.pts_time
              AND (p_pts_gap IS NULL OR vf.pts_time <= rec.pts_time + p_pts_gap)
            ORDER BY vf.pts_time
        LOOP
            IF sim.dist < p_distance THEN
                INSERT INTO loop_frames_result(video_id, frame_pts, similar_pts, distance, last_distance)
                VALUES (p_video_id, rec.pts_time, sim.pts_time, sim.dist, p_distance);

                INSERT INTO tmp_group_member(pts)
                VALUES(sim.pts_time)
                ON CONFLICT DO NOTHING;

                v_has_similar := true;
            END IF;
        END LOOP;

        IF NOT v_has_similar THEN
            INSERT INTO loop_frames_result(video_id, frame_pts, similar_pts, distance, last_distance)
            VALUES(p_video_id, rec.pts_time, NULL, NULL, p_distance);
        END IF;

        INSERT INTO tmp_group_member(pts)
        VALUES(rec.pts_time)
        ON CONFLICT DO NOTHING;
    END LOOP;

    RETURN QUERY
    SELECT r.frame_pts, r.similar_pts, r.distance
    FROM loop_frames_result r
    WHERE r.video_id = p_video_id
    ORDER BY r.frame_pts, r.distance, r.similar_pts;
END;
$$ LANGUAGE plpgsql;
