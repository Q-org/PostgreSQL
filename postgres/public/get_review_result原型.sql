SELECT
	"p"."id", 
	"p".md AS result, 
	"p".video_id
  ,version_tag
FROM
	video_review_platform AS "p"
WHERE
-- 	"p"."id" = 4 
   p.video_id = '4e828a08-9724-4a85-b551-37ba502750b7'::UUID
  ;

SELECT * FROM public.get_review_result(4);