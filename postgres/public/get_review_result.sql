DROP FUNCTION IF EXISTS get_review_result(bigint);

CREATE OR REPLACE FUNCTION get_review_result(p_id bigint)
RETURNS TABLE (
    id bigint,
    result text,
    video_id uuid
)
LANGUAGE sql
AS $$
SELECT
    p.id,
    p.md AS  "result",
    p.video_id
FROM video_review_platform AS p
WHERE p.id = p_id;
$$;
