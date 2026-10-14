DROP FUNCTION IF EXISTS review_parse_result0(integer);
CREATE OR REPLACE FUNCTION review_parse_result0(p_task_id int)
RETURNS TABLE (
    video_id uuid,
    risk_id uuid,
    risk_name text,
    note text,
    pts_time double precision
) AS $$
BEGIN
    RETURN QUERY
    WITH md AS (
        SELECT t.video_id, t.result AS txt  from public.get_review_result(p_task_id) t
    )
    ,seq_page as (
        -- process_video_review 返回的表，给别名 pv，pv.seq pv.pts_time
        SELECT md.video_id, pv.seq, pv.pts_time
        FROM md
        CROSS JOIN LATERAL process_video_review(md.video_id) pv
    )
    ,blocks as (
        SELECT
            md.video_id,
           (regexp_match(m, $re$^####.+?\x60([^\x60]+)\x60$re$))[1] AS risk_tag,
            trim(both $re$\n$re$ from m) AS block
        FROM md
        CROSS JOIN regexp_split_to_table(
            md.txt,
            $re$(?=####\s+(\d+)\.?)$re$
        ) WITH ORDINALITY AS t(m, ord)
        WHERE m ~* $re$#{4}\s+\d+\.$re$
    )
    ,risk as ( --   review_risk
        SELECT b.* ,r.risk_name,r.risk_code,r.id AS risk_id
        from blocks AS b
        LEFT JOIN review_risk AS r ON r.risk_name = b.risk_tag OR r.risk_code = b.risk_tag
    )
    ,page_raw AS (
        SELECT r.*
        ,(regexp_match(t.m, $page$(\d+(、\d+)*)$page$))[1] AS page
        ,(regexp_match(t.m, $re$^.+：(.+)$re$))[1] as note
        ,t.m
        from risk as r
        CROSS JOIN regexp_split_to_table(
            r.block,
            $line$(?=(?:\s+\*\*)?(?:Page|页码)：?\s*\d+.+)$line$
        ) WITH ORDINALITY AS t(m, ord)
        WHERE t.m ~*  $line$(?=(?:\s+\*\*)?(?:Page|页码)：?\s*\d+.+)$line$
    )
    ,raw AS(
        SELECT
         p.risk_id,
         p.risk_name,
         p.note,
         split_page AS page
        FROM page_raw AS p
        CROSS JOIN regexp_split_to_table(p.page, $re$、$re$) AS split_page
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
        ON res.risk_id = r.risk_id AND res.pts_time = s.pts_time
    WHERE  res.id is  null;
END;
$$ LANGUAGE plpgsql;
