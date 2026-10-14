WITH md AS (
    select video_id, result AS txt  from public.get_review_result(21)
)
-- ,seq_page as (
SELECT md.video_id, seq,pts_time
FROM md
CROSS JOIN LATERAL get_mission_jpg(md.video_id)
)
,blocks as (
SELECT
    md.video_id,
   (regexp_match(m, E'^####.+?`([^`]+)`'))[1] AS risk_tag,
    trim(both E'\n' from m) AS block
FROM md,
regexp_split_to_table(
    txt,
    $$(?=####\s+(\d+)\.?)$$
) WITH ORDINALITY AS t(m, ord)
WHERE m ~* $$#{4}\s+\d+\.$$
) 
,risk as (
SELECT b.* ,r.risk_name,r.risk_code,r.id AS risk_id from blocks AS b
LEFT JOIN review_risk AS r ON r.risk_name=  b.risk_tag OR r.risk_code =  b.risk_tag 
)
,page_raw AS (
SELECT 
r.*  

,(regexp_match(m, $提取$(\d+(、\d+)*)$提取$))[1] AS page 
,(regexp_match(m, E'^.+?：(.+)$'))[1] as note  -- 有这个  28 报错 ERROR:  syntax error at or near "("
,t.m 
from risk as r,
regexp_split_to_table(
    r.block,
    $分行$(?=(?:\*\s+\*\*|Page)\s+\d+.+$)$分行$  -- ✅正向预查：* **Page 数字 前面的位置分割
) WITH ORDINALITY AS t(m, ord)
WHERE m ~* $分行$(\*\s+\*\*|Page\s+)\d+$分行$
)
,raw AS(
SELECT 
 p.risk_id,
 p.risk_name,
 p.note
,split_page AS page
FROM page_raw AS p 
,regexp_split_to_table(p.page, $page$、$page$) AS split_page
)
SELECT 
    s.video_id, 
    r.risk_id,
    r.risk_name,
    r.note,
    s.pts_time
    , r.page,res.id
from raw as r 
INNER JOIN seq_page AS s 
    ON s.seq = r.page::bigint
LEFT JOIN analysis_result AS res 
ON res.risk_id= r.risk_id AND   s.pts_time=res.pts_time 
WHERE  res.id is  null
;

SELECT * FROM public.review_parse_result1(21)
-- 结果集 插入  analysis_result   raw  jsonb  
