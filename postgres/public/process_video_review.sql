DROP FUNCTION IF EXISTS public.process_video_review(uuid,INT);

CREATE OR REPLACE FUNCTION public.process_video_review(
    in_video_id uuid,
    p_th_hamming int DEFAULT 8
)
RETURNS TABLE (
    seq bigint,
    keep_idx bigint,
    pts_time double precision,
    has_image boolean,
    member_idxs jsonb,
    member_count bigint,
    dedup_count bigint,
    review_frame_img_path text
)
LANGUAGE sql STABLE AS $$
WITH params AS (
    SELECT p_th_hamming AS th_hamming
),
matched AS (
    SELECT
        f.idx,
        CASE WHEN f.idx = 0 THEN NULL::bigint
             ELSE (
                SELECT MIN(e.idx) FROM video_frames e
                WHERE e.video_id = f.video_id
                  AND e.idx < f.idx
                  AND bit_count(e.phash_bits # f.phash_bits) <= (SELECT th_hamming FROM params)
             )
        END AS anchor_idx
    FROM video_frames f
    WHERE f.video_id = in_video_id
),
clusters AS (
    SELECT
        COALESCE(anchor_idx, idx) AS keep_idx,
        jsonb_agg(idx ORDER BY idx) AS member_idxs,
        COUNT(*) AS member_count
    FROM matched
    GROUP BY COALESCE(anchor_idx, idx)
)
SELECT
    ROW_NUMBER() OVER (ORDER BY c.keep_idx)::bigint AS seq,
    c.keep_idx,
    f.pts_time,
    f.has_image,
    c.member_idxs,
    c.member_count,
    (c.member_count - 1)::bigint AS dedup_count,
    REGEXP_REPLACE(vm.file_path, '\.[^.]+$', '')
        || '/frame_snap/frame_' || c.keep_idx || '.jpg' AS review_frame_img_path
FROM clusters c
JOIN video_frames f ON f.video_id = in_video_id AND f.idx = c.keep_idx
JOIN video_meta vm  ON vm.id = in_video_id
ORDER BY c.keep_idx;
$$;
