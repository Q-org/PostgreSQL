DROP FUNCTION IF EXISTS public.process_video_review(in_video_id uuid);
CREATE OR REPLACE FUNCTION public.process_video_review(in_video_id uuid)
RETURNS TABLE (
    start_idx bigint,
    end_idx bigint,
    start_pts double precision,
    end_pts double precision,
    min_hamming int,
    max_hamming int,
    frame_count bigint,
    similar_pair_count bigint,
    review_idx bigint,
    risk_level text, -- 算法自动画面相似度风险
    has_image boolean,
    review_risk_labels text, -- 人工评审风险中文名称，逗号分隔
    review_risk_codes text, -- 风险编码
    max_review_risk_level int -- 片段内最高人工风险等级(1最严重)
)
LANGUAGE sql STABLE AS $$
WITH frame_dist AS (
    SELECT
        vf.id AS frame_id,
        vf.risk_ids,
        idx,
        pts_time,
        has_image,
        bit_count(phash_bits # LAG(phash_bits) OVER(PARTITION BY video_id ORDER BY idx)) AS ham_dist
    FROM video_frames vf
    WHERE video_id = in_video_id
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
        CASE
            WHEN MIN(gs.ham_dist) <= 5 THEN '高风险：静态画面，重点审核'
            WHEN MIN(gs.ham_dist) BETWEEN 6 AND 15 THEN '中风险：画面变化小，建议审核'
            ELSE '低风险：画面小幅波动，可忽略'
        END AS risk_level,
        BOOL_OR(gs.has_image) AS has_img_flag,
        ARRAY_AGG(DISTINCT rr.risk_name) FILTER (WHERE rr.risk_name IS NOT NULL) AS risk_name_arr,
        ARRAY_AGG(DISTINCT rr.risk_code) FILTER (WHERE rr.risk_code IS NOT NULL) AS risk_code_arr,
        MAX(rr.risk_level) AS max_risk_lv
    FROM group_seg gs
    LEFT JOIN frame_risk_flat frf ON gs.group_id = frf.group_id
    LEFT JOIN review_risk rr ON frf.risk_id = rr.id
    GROUP BY gs.group_id
)
SELECT
    start_idx,
    end_idx,
    start_pts,
    end_pts,
    min_hamming,
    max_hamming,
    frame_count,
    similar_pair_count,
    review_idx,
    risk_level,
    has_img_flag,
    -- 无人工风险标记时输出「正常」
    CASE WHEN risk_name_arr IS NULL OR array_length(risk_name_arr,1)=0 THEN '正常' ELSE array_to_string(risk_name_arr, ',') END AS review_risk_labels,
    CASE WHEN risk_code_arr IS NULL OR array_length(risk_code_arr,1)=0 THEN '正常' ELSE array_to_string(risk_code_arr, ',') END AS review_risk_codes,
    max_risk_lv AS max_review_risk_level
FROM seg_agg
WHERE similar_pair_count > 0
ORDER BY start_idx;
$$;
