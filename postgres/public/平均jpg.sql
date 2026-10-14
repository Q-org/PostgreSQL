SELECT
	"m"."id", 
	"m".file_path, 
	"m".duration, 
	"m".duration * 0.2 AS duration_02, 
	sum(f.img_size)/1024/1024 AS total_img_size_mb,
	COUNT(*) AS total_frame_cnt,
	COUNT(*) FILTER (WHERE f.img_size IS NULL) AS null_img_size_cnt,
	COUNT(*) FILTER (WHERE f.img_size IS NOT NULL) AS valid_img_size_cnt,
	round( sum(f.img_size)/1024 / NULLIF(COUNT(*) FILTER (WHERE f.img_size IS NOT NULL),0) ) AS avg_kb_per_frame
FROM
	video_meta AS "m"
INNER JOIN video_frames AS f
	ON f.video_id = "m"."id"
GROUP BY
	"m"."id"
HAVING sum(f.img_size)/1024 > 0;

