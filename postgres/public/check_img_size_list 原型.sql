SELECT
  ROW_NUMBER() OVER(ORDER BY f.video_id, f.pts_time) AS seq,
	f.id, 
--   f.pts_time,
	regexp_replace(m.file_path,'\.\w+$','') || '/frame' || f.pts_time|| '.jpg' image_Path
FROM
	video_frames AS f
	INNER JOIN
	video_meta AS "m"
	ON 
		"m"."id" = f.video_id
WHERE
-- 	f.video_id ='f32b69a1-b843-4a6a-b845-0d81f3a60fb1' AND
  f.img_size IS NULL
  
ORDER BY f.video_id, f.pts_time
;

SELECT * FROM check_img_size_list('f32b69a1-b843-4a6a-b845-0d81f3a60fb1');