WITH cfg AS (
    SELECT 2 AS fps
),
frame_stat AS (
    SELECT
        video_id,
        COUNT(CASE WHEN pts_time IS NOT NULL THEN id END) AS real_frame_count,
        BOOL_OR(has_image = true) AS has_any_image
    FROM video_frames
    WHERE video_id = '4e828a08-9724-4a85-b551-37ba502750b7'
    GROUP BY video_id
)
SELECT
    FLOOR(COALESCE(b.duration,0)*cfg.fps)::bigint AS frame_count,
    COALESCE(fs.real_frame_count,0)::bigint AS real_frame_count,
    REGEXP_REPLACE(b.file_path, '\.[^.]+$','') AS file_path,
    CASE
        WHEN COALESCE(fs.has_any_image,false) = false THEN 'Run'
        WHEN FLOOR(COALESCE(b.duration,0)*cfg.fps) = COALESCE(fs.real_frame_count,0) THEN 'Skip'
        ELSE 'Run'
    END AS status,
    cfg.fps
FROM video_meta b
CROSS JOIN cfg
LEFT JOIN frame_stat fs ON fs.video_id = b.id
WHERE b.id = '4e828a08-9724-4a85-b551-37ba502750b7';


-- 不传fps，自动使用默认值1
--
SELECT * from get_video_frame_info('4e828a08-9724-4a85-b551-37ba502750b7',0.2); 
-- 手动指定fps=2
SELECT * FROM get_video_frame_info('4e828a08-9724-4a85-b551-37ba502750b7',2);
