WITH md AS (
    select video_id, result AS txt  from public.get_review_result(21)
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
    (regexp_match(m, '(?m)^####\s*\d+\.(.+)$'))[1] AS note,
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
,(regexp_match(m, '(?i)p1\(([^()]+)\)'))[1] AS pages
,t.m
from risk as r,
regexp_split_to_table(
    r.block,
    $line$、$line$
) WITH ORDINALITY AS t(m, ord)
)
-- 核心：解析 pages 00:00:01-00:00:08，拆起始、结束时间
,page_time_range AS (
SELECT
    p.video_id,
    p.risk_id,
    p.risk_name,
    p.note,
    p.pages,
    -- 提取起止时间
    (regexp_match(p.pages, '(\d+:\d+:\d+)-(\d+:\d+:\d+)'))[1]::time AS start_ts,
    (regexp_match(p.pages, '(\d+:\d+:\d+)-(\d+:\d+:\d+)'))[2]::time AS end_ts
FROM page_raw AS p
WHERE p.pages ~ '^\d+:\d+:\d+-\d+:\d+:\d+$' -- 过滤合法时间范围字符串
)
, raw as( 
SELECT
    ptr.video_id,
    ptr.risk_id,
    ptr.risk_name,
    ptr.note,
    ptr.pages,
    ptr.start_ts + (gs - 1)*INTERVAL '1 second' AS ts
FROM page_time_range ptr
-- 横向生成序列，逐秒展开
CROSS JOIN LATERAL generate_series(
    1,
    EXTRACT(EPOCH FROM (ptr.end_ts - ptr.start_ts))::integer + 1
) AS gs

)
SELECT
    r.video_id,
    r.risk_id,
    r.risk_name,
    r.note,
    EXTRACT(EPOCH FROM r.ts::time) AS pts_time 
--     ,res.pts_time 
from raw as r
LEFT JOIN analysis_result AS res 
  on r.video_id = res.video_id and EXTRACT(EPOCH FROM r.ts::time)= res.pts_time AND r.risk_id = res.risk_id
WHERE  res.id is  null
;
-- 
-- 
-- SELECT * FROM public.review_parse_result2(21)
-- UNION all
-- SELECT * FROM public.review_parse_result1(21)
-- UNION all
-- SELECT * FROM public.review_parse_result0(21);
-- 结果集 插入  analysis_result   raw  jsonb  
