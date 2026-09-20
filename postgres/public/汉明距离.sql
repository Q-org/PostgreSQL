WITH frame_dist AS (
    SELECT
        idx,
        pts_time,
        has_image,
        risk_ids,
        bit_count(phash_bits # LAG(phash_bits) OVER(PARTITION BY video_id ORDER BY idx)) AS ham_dist
    FROM video_frames
    WHERE video_id = '38f43de3-632c-48e2-9530-be1146708993'::uuid
),
mark_segment AS (
    SELECT
        *,
        CASE WHEN ham_dist > 32 OR ham_dist IS NULL THEN 1 ELSE 0 END AS new_group
    FROM frame_dist
),
group_seg AS (
    SELECT
        *,
        SUM(new_group) OVER(ORDER BY idx) AS group_id
    FROM mark_segment
),
-- 展开risk_ids，一帧多条，无risk_ids自动过滤
frame_risk_flat AS (
    SELECT
        gs.group_id,
        unnest(gs.risk_ids) AS risk_id
    FROM group_seg gs
    WHERE gs.risk_ids IS NOT NULL
),
seg_agg AS (
    SELECT
        MIN(gs.idx) AS start_idx,
        MAX(gs.idx) AS end_idx,
        MIN(gs.pts_time) AS start_pts,
        MAX(gs.pts_time) AS end_pts,
        MIN(gs.ham_dist) AS min_hamming,
        MAX(gs.ham_dist) AS max_hamming,
        COUNT(*) AS frame_count,
        COUNT(CASE WHEN gs.ham_dist <= 12 THEN 1 END) AS similar_pair_count,
        MIN(gs.idx) + (MAX(gs.idx)-MIN(gs.idx))/2 AS review_idx,
        BOOL_OR(gs.has_image) AS has_img_flag,
        CASE WHEN MIN(gs.ham_dist) <=5 THEN '高风险：静态画面，重点审核' ELSE '中风险：画面变化小，建议审核' END AS risk_level,
        -- 人工风险
        CASE
            WHEN string_agg(DISTINCT rr.risk_name, ',') IS NULL THEN '正常'
            ELSE string_agg(DISTINCT rr.risk_name, ',')
        END AS review_risk_labels,
        CASE
            WHEN string_agg(DISTINCT rr.risk_code, ',') IS NULL THEN '正常'
            ELSE string_agg(DISTINCT rr.risk_code, ',')
        END AS review_risk_codes,
        MAX(rr.risk_level) AS max_review_risk_level
    FROM group_seg gs
    LEFT JOIN frame_risk_flat frf ON gs.group_id = frf.group_id
    LEFT JOIN review_risk rr ON frf.risk_id = rr.id
    GROUP BY gs.group_id
    HAVING COUNT(CASE WHEN gs.ham_dist <= 12 THEN 1 END) > 0
)
SELECT
    ROW_NUMBER() OVER(ORDER BY start_idx) AS seq, -- 新增序号
    start_idx,
    end_idx,
    start_pts,
    end_pts,
    min_hamming,
    max_hamming,
    frame_count,
    similar_pair_count,
    review_idx,
    has_img_flag,
    risk_level,
    review_risk_labels,
    review_risk_codes,
    max_review_risk_level
FROM seg_agg
ORDER BY start_idx;


SELECT * FROM  public.process_video_review('38f43de3-632c-48e2-9530-be1146708993')

