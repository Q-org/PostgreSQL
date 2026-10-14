DROP FUNCTION IF EXISTS public.review_parse_result1(int);
DROP FUNCTION IF EXISTS public.review_parse_result1(int, numeric);

CREATE OR REPLACE FUNCTION public.review_parse_result1(
    p_review_id integer,
    sparsityOfSampling numeric DEFAULT 0.2
)
RETURNS TABLE(
    video_id  uuid,
    risk_id   uuid,
    risk_name text,
    note      text,
    pts_time  double precision
)
LANGUAGE sql
STABLE
AS $func$
WITH md AS (
    SELECT video_id, result AS txt
    FROM public.get_review_result(p_review_id)
),
seq_page AS (
    SELECT md.video_id, seq, pts_time
    FROM md
    CROSS JOIN LATERAL public.get_mission_jpg(md.video_id, sparsityOfSampling)
),
blocks AS (
    SELECT
        md.video_id,
        (regexp_match(m, '^####.+?`([^`]+)`'))[1] AS risk_tag,
        trim(both E'\n' FROM m) AS block
    FROM md,
         regexp_split_to_table(txt, '(?=####\s+(\d+)\.?)') WITH ORDINALITY AS t(m, ord)
    WHERE m ~* '#{4}\s+\d+\.'
),
risk AS (
    SELECT b.*, r.risk_name, r.risk_code, r.id AS risk_id
    FROM blocks AS b
    LEFT JOIN public.review_risk AS r
        ON r.risk_name = b.risk_tag OR r.risk_code = b.risk_tag
),
page_raw AS (
    SELECT
        r.*,
        (regexp_match(m, '(\d+(、\d+)*)'))[1] AS page,
        (regexp_match(m, '^.+?：(.+)$'))[1]  AS note
    FROM risk AS r,
         regexp_split_to_table(r.block, '(?=(?:\*\s+\*\*|Page)\s+\d+.+$)') WITH ORDINALITY AS t(m, ord)
    WHERE m ~* '(\*\s+\*\*|Page\s+)\d+'
),
raw AS (
    SELECT
        p.risk_id,
        p.risk_name,
        p.note,
        split_page AS page
    FROM page_raw AS p,
         regexp_split_to_table(p.page, '、') AS split_page
)
SELECT
    s.video_id,
    r.risk_id,
    r.risk_name,
    r.note,
    s.pts_time
FROM raw AS r
INNER JOIN seq_page AS s ON s.seq = r.page::bigint
LEFT JOIN public.analysis_result AS res
    ON res.risk_id = r.risk_id AND s.pts_time = res.pts_time
WHERE res.id IS NULL
$func$;
