WITH meta AS (
SELECT 
  id AS video_id,
  file_path AS video_path,
  duration ,
  video_codec,
  video_fps
FROM video_meta
WHERE id = '4e828a08-9724-4a85-b551-37ba502750b7' 
),
src AS (
    SELECT
        a.video_id,
        a.pts_time,
        a.risk_id,
        r.risk_level
    FROM analysis_result AS a
    cross join  meta 
    INNER JOIN review_risk AS r ON a.risk_id = r.id
    WHERE
        a.video_id = meta.video_id
        AND r.risk_level > 1
),
ordered AS (
    SELECT
        *,
        -- 取上一行pts_time
        LAG(pts_time) OVER(PARTITION BY video_id ORDER BY pts_time) AS prev_pts
    FROM src
),
island_mark AS (
    SELECT
        *,
        -- 当前与上一个pts差值 >=2 → 新岛，标记1；否则0；累加得到组id
        CASE WHEN prev_pts IS NULL OR pts_time - prev_pts >= 2 THEN 1 ELSE 0 END AS is_new_group
    FROM ordered
),
island_id AS (
    SELECT
        *,
        SUM(is_new_group) OVER(PARTITION BY video_id ORDER BY pts_time) AS group_id
    FROM island_mark
),
segms AS (
SELECT
    a.video_id,
    MIN(pts_time) AS start_pts,
    MAX(pts_time) AS end_pts,
    JSONB_AGG(DISTINCT risk_id) AS risk_ids,
    JSONB_AGG(DISTINCT risk_level) AS risk_levels
FROM island_id AS a 
GROUP BY a.video_id, group_id
ORDER BY start_pts ASC
) 
SELECT
  meta.video_id,
  meta.video_path,
  meta.duration ,
  meta.video_codec,
  meta.video_fps, 
  segms.start_pts,
  segms.end_pts,
  segms.risk_ids,
  segms.risk_levels
FROM segms 
CROSS JOIN meta ;

SELECT  * FROM  public.get_segments_blur('82196689-95b5-462f-bd7e-f5a5a3f95335')