WITH result AS (
    SELECT
        r.a_pts AS keep_pts,
        r.b_pts_list,
        r.dist_list
    FROM loop_frames(
        '3b06d824-d067-455c-8395-9948d8a59278'::uuid
    ) r
),

expanded AS (
    SELECT
        r.keep_pts AS frame_pts,
        b.pts::numeric AS similar_pts
    FROM result r
    CROSS JOIN LATERAL jsonb_array_elements_text(
        r.b_pts_list
    ) AS b(pts)
),

group_range AS (

    -- 有相似帧的组
    SELECT
        e.frame_pts AS base_pts,

        MIN(
            LEAST(
                e.frame_pts,
                e.similar_pts
            )
        ) AS clip_start_pts,

        MAX(
            GREATEST(
                e.frame_pts,
                e.similar_pts
            )
        ) AS clip_end_pts,

        jsonb_agg(
            DISTINCT e.similar_pts
            ORDER BY e.similar_pts
        ) AS similar_member_pts,

        COUNT(
            DISTINCT e.similar_pts
        )::bigint AS member_count

    FROM expanded e
    GROUP BY e.frame_pts

    UNION ALL

    -- 没有相似帧的组
    SELECT
        r.keep_pts AS base_pts,
        r.keep_pts AS clip_start_pts,
        r.keep_pts AS clip_end_pts,
        '[]'::jsonb AS similar_member_pts,
        0::bigint AS member_count

    FROM result r

    WHERE r.b_pts_list IS NULL
       OR jsonb_array_length(r.b_pts_list) = 0
),

raw_result AS (
    SELECT
        gr.base_pts AS keep_pts,

        t_base.idx AS keep_idx,

        (
            jsonb_build_array(gr.base_pts)
            || gr.similar_member_pts
        ) AS member_pts,

        gr.member_count,

        (gr.member_count + 1)::bigint AS dedup_count,

        t_base.pts_time,

        t_base.has_image,

        REGEXP_REPLACE(
            vm.file_path,
            '\.[^.]+$',
            ''
        )
        || '/frame'
        || t_base.pts_time
        || '.jpg' AS review_frame_img_path

    FROM group_range gr

    JOIN video_frames t_base
      ON t_base.video_id =
           '3b06d824-d067-455c-8395-9948d8a59278'::uuid
     AND t_base.pts_time = gr.base_pts

    JOIN video_frames t_start
      ON t_start.video_id =
           '3b06d824-d067-455c-8395-9948d8a59278'::uuid
     AND t_start.pts_time = gr.clip_start_pts

    JOIN video_frames t_end
      ON t_end.video_id =
           '3b06d824-d067-455c-8395-9948d8a59278'::uuid
     AND t_end.pts_time = gr.clip_end_pts

    JOIN video_meta vm
      ON vm.id =
           '3b06d824-d067-455c-8395-9948d8a59278'::uuid
),

filtered_result AS (
    SELECT
        r.*
    FROM raw_result r

    WHERE NOT EXISTS (
        SELECT 1
        FROM raw_result prev

        WHERE prev.keep_pts < r.keep_pts

          -- 当前 keep_pts 已经被前面某个组包含
          AND prev.member_pts @> jsonb_build_array(
              r.keep_pts
          )
    )
)

SELECT
    ROW_NUMBER() OVER (
        ORDER BY fr.keep_pts
    ) AS seq,

    fr.keep_pts,

    fr.keep_idx,

    fr.member_pts,

    fr.member_count,

    fr.dedup_count,

    fr.pts_time,

    fr.has_image,

    fr.review_frame_img_path

FROM filtered_result fr

ORDER BY fr.keep_pts;

select * FROM public.process_video_review('3b06d824-d067-455c-8395-9948d8a59278'::uuid);

