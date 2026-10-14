WITH md AS (
    select video_id, result AS txt  from public.get_review_result(21)
)
,seq_page as (
SELECT md.video_id, seq,pts_time
FROM md
CROSS JOIN LATERAL process_video_review(md.video_id)
)
,blocks as (
SELECT
    md.video_id,
    COALESCE(
      -- 模式1：#### 任意内容 `目标`
      (regexp_match(m, '^####[^`]+`([^`]+)`'))[1],
      -- 模式2：#### 数字.  直接捕获，空格/`作为终止符
      (regexp_match(m,'^####\s*\d+\.\s*([^\s`]+)'))[1]
      ) AS risk_tag,
    trim(both $re$\n$re$ from m) AS block
FROM md,
regexp_split_to_table(
    txt,
    $re$(?=####\s+(\d+)\.?)$re$
) WITH ORDINALITY AS t(m, ord)
WHERE m ~* $re$#{4}\s+\d+\.$re$
)
,risk as ( --   review_risk
SELECT b.* ,r.risk_name,r.risk_code,r.id AS risk_id from blocks AS b
LEFT JOIN review_risk AS r ON r.risk_name=  b.risk_tag OR r.risk_code=  b.risk_tag
)
,page_raw AS (
SELECT r.*
,(regexp_match(m, $page$(\d+(、\d+)*)$page$))[1] AS page
,(regexp_match(m, $re$^.+：(.+)$re$))[1] as note
,t.m
from risk as r,
regexp_split_to_table(
    r.block,
    $line$(?=(?:\s+\*\*)?(?:Page|页码)：?\s*\d+.+)$line$  -- ✅补全 )
) WITH ORDINALITY AS t(m, ord)
WHERE m ~*  $line$(?=(?:\s+\*\*)?(?:Page|页码)：?\s*\d+.+)$line$
)
,raw AS(
SELECT
 p.risk_id,
 p.risk_name,
 p.note,
split_page AS page
FROM page_raw AS p
,regexp_split_to_table(p.page, $re$、$re$) AS split_page
)
SELECT
    s.video_id,
    r.risk_id,
    r.risk_name,
    r.note,
    s.pts_time
from raw as r
INNER JOIN seq_page AS s
    ON s.seq = r.page::bigint
LEFT JOIN analysis_result AS res
ON res.risk_id= r.risk_id AND   s.pts_time=res.pts_time
WHERE  res.id is  null
;
-- 
-- 
SELECT * FROM public.review_parse_result0(21)
-- UNION all
-- SELECT * FROM public.review_parse_result1(21);
-- UNION all
-- SELECT * FROM public.review_parse_result2(21);
-- 结果集 插入  analysis_result   raw  jsonb  
