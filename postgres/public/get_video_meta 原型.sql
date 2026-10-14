WITH CONST AS (
SELECT 
'3ac8914f-4ece-4210-a2e2-1790f2714fdc'::UUID AS P_VIDEO_ID
-- ,replace('E:/266/C-沉溺于你（欧美）AI竖屏/1-45中字.mp41','\','/') 
,null AS P_FILE_PATH 
)
SELECT
	"m"."id", 
	"m".raw, 
	"m".file_hash, 
	"m".file_path, 
  COALESCE(
    (regexp_match(m.file_path, '/(?!.*\d+-\d+)([^/]+)\.\w+$'))[1],
    (regexp_match(m.file_path, '^.*/(?:[a-zA-Z]+-?)?(.+?)(（.*$|/[^/]+$)'))[1]
  ) ,
	"m".video_fps, 
	"m".duration, 
	"m".video_width, 
	"m".video_height, 
	"m".file_name, 
	"m".file_size, 
	"m".video_codec, 
	"m".video_format
FROM
	video_meta AS "m"
CROSS JOIN CONST AS C
WHERE
	"m"."id" = C.P_VIDEO_ID OR
  m.file_path =  c.P_FILE_PATH 
  
  ;
-- 传 UUID
SELECT * FROM get_video_meta('3ac8914f-4ece-4210-a2e2-1790f2714fdc'::uuid);
-- 传路径
SELECT * FROM get_video_meta('E:/266/C-沉溺于你（欧美）AI竖屏/1-45中字.mp4');