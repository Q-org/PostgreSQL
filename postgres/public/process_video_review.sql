DROP FUNCTION IF EXISTS process_video_review(uuid);
DROP FUNCTION IF EXISTS process_video_review(uuid, integer);

CREATE OR REPLACE FUNCTION process_video_review(
    p_video_id uuid,
    p_phash_threshold int
)
RETURNS TABLE (
    seq bigint,
    keep_idx bigint,
    keep_pts numeric,
    member_pts jsonb,
    member_count bigint,
    dedup_count bigint,
    pts_time numeric,
    has_image boolean,
    review_frame_img_path text
)
LANGUAGE plpgsql
VOLATILE
AS $$
BEGIN
    RETURN QUERY
WITH frames AS (
    SELECT
        f.id,
        f.pts_time,
        f.phash_bits
    FROM video_frames f
    WHERE f.video_id = p_video_id
      AND f.phash_bits IS NOT NULL
),
result AS (
    SELECT
        f1.pts_time AS keep_pts,
        COALESCE(t.b_pts_list, '[]'::jsonb) AS b_pts_list,
        COALESCE(t.dist_list, '[]'::jsonb) AS dist_list
    FROM frames f1
    LEFT JOIN LATERAL (
        SELECT
            jsonb_agg(f2.pts_time ORDER BY f2.pts_time) AS b_pts_list,
            jsonb_agg(bit_count(f1.phash_bits # f2.phash_bits) ORDER BY f2.pts_time) AS dist_list
        FROM frames f2
        WHERE f2.pts_time > f1.pts_time
          AND bit_count(f1.phash_bits # f2.phash_bits) < p_phash_threshold
    ) t ON true
),
expanded AS (
    SELECT
        r.keep_pts AS frame_pts,
        b.pts::numeric AS similar_pts
    FROM result r
    CROSS JOIN LATERAL jsonb_array_elements_text(r.b_pts_list) AS b(pts)
),
group_range AS (
    SELECT
        e.frame_pts AS base_pts,
        MIN(LEAST(e.frame_pts, e.similar_pts)) AS clip_start_pts,
        MAX(GREATEST(e.frame_pts, e.similar_pts)) AS clip_end_pts,
        jsonb_agg(DISTINCT e.similar_pts ORDER BY e.similar_pts) AS similar_member_pts,
        COUNT(DISTINCT e.similar_pts)::bigint AS member_count
    FROM expanded e
    GROUP BY e.frame_pts

    UNION ALL

    SELECT
        r.keep_pts AS base_pts,
        r.keep_pts AS clip_start_pts,
        r.keep_pts AS clip_end_pts,
        '[]'::jsonb AS similar_member_pts,
        0::bigint AS member_count
    FROM result r
    WHERE jsonb_array_length(r.b_pts_list) = 0
),
raw_result AS (
    SELECT
        gr.base_pts AS keep_pts,
        t_base.idx::bigint AS keep_idx,
        (jsonb_build_array(gr.base_pts) || gr.similar_member_pts) AS member_pts,
        gr.member_count::bigint AS member_count,
        (gr.member_count + 1)::bigint AS dedup_count,
        t_base.pts_time,
        t_base.has_image,
        REGEXP_REPLACE(vm.file_path, '\.[^.]+$', '') || '/frame' || t_base.pts_time || '.jpg' AS review_frame_img_path
    FROM group_range gr
    JOIN video_frames t_base
      ON t_base.video_id = p_video_id
      AND ABS(t_base.pts_time - gr.base_pts) < 0.001
    JOIN video_frames t_start
      ON t_start.video_id = p_video_id
      AND ABS(t_start.pts_time - gr.clip_start_pts) < 0.001
    JOIN video_frames t_end
      ON t_end.video_id = p_video_id
      AND ABS(t_end.pts_time - gr.clip_end_pts) < 0.001
    JOIN video_meta vm
      ON vm.id = p_video_id
),
filtered_result AS (
    SELECT
        rr.keep_pts,
        rr.keep_idx,
        rr.member_pts,
        rr.member_count,
        rr.dedup_count,
        rr.pts_time,
        rr.has_image,
        rr.review_frame_img_path
    FROM raw_result rr
    WHERE NOT EXISTS (
        SELECT 1
        FROM raw_result prev
        WHERE prev.keep_pts < rr.keep_pts
          AND prev.member_pts @> jsonb_build_array(rr.keep_pts)
    )
)
SELECT
    ROW_NUMBER() OVER (ORDER BY fr.keep_pts)::bigint AS seq,
    fr.keep_idx::bigint,
    fr.keep_pts::numeric,
    fr.member_pts::jsonb,
    fr.member_count::bigint,
    fr.dedup_count::bigint,
    fr.pts_time::numeric,
    fr.has_image::boolean,
    fr.review_frame_img_path::text
FROM filtered_result fr
ORDER BY fr.keep_pts;
END;
$$;

CREATE OR REPLACE FUNCTION process_video_review(p_video_id uuid)
RETURNS TABLE (
    seq bigint,
    keep_idx bigint,
    keep_pts numeric,
    member_pts jsonb,
    member_count bigint,
    dedup_count bigint,
    pts_time numeric,
    has_image boolean,
    review_frame_img_path text
)
LANGUAGE plpgsql
VOLATILE
AS $$
BEGIN
    RETURN QUERY SELECT * FROM process_video_review(p_video_id, 12::int);
END;
$$;
