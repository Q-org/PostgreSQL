    SELECT
        FLOOR(b.video_duration * 1 ) AS frame_count,
        COUNT(a.id) AS real_frame_count,
        CASE
            WHEN COUNT(a.has_image ) =0  THEN 'Run'
            WHEN FLOOR(b.video_duration * 1) = COUNT(a.id) THEN 'Skip'
            WHEN FLOOR(b.video_duration * 1) <= COUNT(a.id) THEN 'Run'
            ELSE 'Run'
        END AS status
    FROM video_meta AS b
    LEFT JOIN video_frames AS a
        ON a.video_id = b."id"
    WHERE b."id" = 'd005c9e7-abf2-4bb4-bbff-37189088013e'
    GROUP BY b."id", b.video_duration;

-- 不传fps，自动使用默认值1
--
SELECT * from get_video_frame_info('d005c9e7-abf2-4bb4-bbff-37189088013e'); 
-- 手动指定fps=2
SELECT * FROM get_video_frame_info('d005c9e7-abf2-4bb4-bbff-37189088013e',2);
