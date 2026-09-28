WITH cfg AS (
    SELECT 2 AS fps
),
frame_stat AS (
    SELECT
        video_id,
        COUNT(CASE WHEN pts_time IS NOT NULL THEN id END) AS real_frame_count,
        BOOL_OR(has_image = true) AS has_any_image
    FROM video_frames
    WHERE video_id = '2a0ce50a-3243-4b2f-9fba-273611399a63'
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
WHERE b.id = '2a0ce50a-3243-4b2f-9fba-273611399a63';


-- 不传fps，自动使用默认值1
--
SELECT * from get_video_frame_info('2a0ce50a-3243-4b2f-9fba-273611399a63'); 
-- 手动指定fps=2
SELECT * FROM get_video_frame_info('2a0ce50a-3243-4b2f-9fba-273611399a63',2);
