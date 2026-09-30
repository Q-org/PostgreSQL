WITH frames AS (
    SELECT
        f.id,
        f.pts_time,
        f.phash_bits
    FROM video_frames f
    WHERE f.video_id = '8648ec25-a389-4901-9916-be5908eaf447'
      AND f.phash_bits IS NOT NULL
)
SELECT
    f1.pts_time AS a_pts,
    jsonb_agg(f2.pts_time ORDER BY f2.pts_time) AS b_pts_list,
    jsonb_agg(bit_count(f1.phash_bits # f2.phash_bits) ORDER BY f2.pts_time) AS dist_list
FROM frames f1
JOIN frames f2
  ON f1.pts_time <= f2.pts_time
  AND bit_count(f1.phash_bits # f2.phash_bits) < 8
GROUP BY f1.pts_time
ORDER BY a_pts;
