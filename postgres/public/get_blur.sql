SELECT
format(
    'pnpm -F @tools/video-proc video-engine blur  --keyframe-only  --ff "ahash,dhash,phash" --blur-sigma 300  -i "%s" --blur-range  "%s" --blur-region 95%%',
    video_path,
    COALESCE(segment_list, '')
  ) AS CMD

FROM(
SELECT
  string_agg(make_interval(secs := start_pts)::time || '-' || make_interval(secs :=end_pts)::TIME, ',') AS segment_list,
  MAX(video_path) AS video_path
FROM public.get_segments_blur('4e828a08-9724-4a85-b551-37ba502750b7')
) t;
-- 00:32:23-00:32:51,00:32:22-00:32:45