WITH const AS (
    SELECT
        0.2::numeric AS fps,
        0::numeric AS base
),

/*
 * 1. 视频基本信息
 *
 * base = 0
 * step = 1 / fps
 */
video_info AS (
    SELECT
        m.id AS video_id,
        m.duration::numeric AS duration,
        c.fps,
        c.base,
        ROUND(1.0 / c.fps, 6) AS step
    FROM video_meta AS m
    CROSS JOIN const AS c
    WHERE m.id = '3b06d824-d067-455c-8395-9948d8a59278'
),

/*
 * 2. 根据 base + n * step
 *    生成理论上应该存在的所有 pts
 */
expected_pts AS (
    SELECT
        v.video_id,
        v.duration,
        v.fps,
        v.base,
        v.step,
        gs.n,

        ROUND(
            v.base + gs.n * v.step,
            6
        ) AS pts

    FROM video_info AS v

    CROSS JOIN LATERAL generate_series(
        0,
        FLOOR(
            (v.duration - v.base) / v.step
        )::bigint
    ) AS gs(n)

    WHERE v.step > 0
),

/*
 * 3. 检查这些 pts 在 video_frames 中是否存在
 */
frems AS (
    SELECT
        e.video_id,
        e.duration,
        e.fps,
        e.base,
        e.step,
        e.n,
        e.pts,
        f.pts_time,
        f.id

    FROM expected_pts AS e

    LEFT JOIN video_frames AS f
        ON f.video_id = e.video_id
       AND ABS(
            f.pts_time - e.pts
       ) <= 0.000001
),

/*
 * 4. 汇总统计
 */
stat AS (
    SELECT
        video_id,
        duration,
        fps,
        base,
        step,

        /*
         * 所有理论 pts
         */
        ARRAY_AGG(
            pts
            ORDER BY pts
        ) AS pts_arr,

        /*
         * 实际已经存在的 pts
         */
        ARRAY_AGG(
            pts
            ORDER BY pts
        ) FILTER (
            WHERE id IS NOT NULL
        ) AS existing_pts_arr,

        /*
         * 缺失的 pts
         */
        ARRAY_AGG(
            pts
            ORDER BY pts
        ) FILTER (
            WHERE id IS NULL
        ) AS missing_pts_arr,

        COUNT(*) AS total_sample_points,

        COUNT(*) FILTER (
            WHERE id IS NOT NULL
        ) AS matched_frames,

        COUNT(*) FILTER (
            WHERE id IS NULL
        ) AS missing_frames

    FROM frems

    GROUP BY
        video_id,
        duration,
        fps,
        base,
        step
)

/*
 * 5. 最终结果
 */
SELECT
    *,
    CASE
        WHEN missing_frames = 0
            THEN 'skip'
        ELSE 'run'
    END AS status

FROM stat;


SELECT  *  FROM   public.get_video_frame_stat('3b06d824-d067-455c-8395-9948d8a59278',1)