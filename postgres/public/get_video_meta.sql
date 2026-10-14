-- 清理旧版本
DROP FUNCTION IF EXISTS public.get_video_meta(uuid);
DROP FUNCTION IF EXISTS public.get_video_meta(text);

-- 版本1：入参 uuid
CREATE OR REPLACE FUNCTION public.get_video_meta(p_video_id uuid)
RETURNS TABLE (
    id uuid,
    raw text,
    file_hash text,
    file_path text,
    dry_name text,
    video_fps numeric,
    duration numeric,
    video_width integer,
    video_height integer,
    file_name text,
    file_size bigint,
    video_codec text,
    video_format text
)
LANGUAGE sql
STABLE
AS $$
SELECT
    m.id,
    m.raw,
    m.file_hash,
    m.file_path,
    COALESCE(
        (regexp_match(m.file_path, '/(?!.*\d+-\d+)([^/]+)\.\w+$'))[1],
        (regexp_match(m.file_path, '^.*/(?:[a-zA-Z]+-?)?(.+?)(（.*$|/[^/]+$)'))[1]
    ) AS dry_name,
    m.video_fps,
    m.duration,
    m.video_width,
    m.video_height,
    m.file_name,
    m.file_size,
    m.video_codec,
    m.video_format
FROM video_meta AS m
WHERE m.id = p_video_id;
$$;

-- 版本2：入参 text（文件路径）
CREATE OR REPLACE FUNCTION public.get_video_meta(p_file_path text)
RETURNS TABLE (
    id uuid,
    raw text,
    file_hash text,
    file_path text,
    dry_name text,
    video_fps numeric,
    duration numeric,
    video_width integer,
    video_height integer,
    file_name text,
    file_size bigint,
    video_codec text,
    video_format text
)
LANGUAGE sql
STABLE
AS $$
SELECT
    m.id,
    m.raw,
    m.file_hash,
    m.file_path,
    COALESCE(
        (regexp_match(m.file_path, '/(?!.*\d+-\d+)([^/]+)\.\w+$'))[1],
        (regexp_match(m.file_path, '^.*/(?:[a-zA-Z]+-?)?(.+?)(（.*$|/[^/]+$)'))[1]
    ) AS dry_name,
    m.video_fps,
    m.duration,
    m.video_width,
    m.video_height,
    m.file_name,
    m.file_size,
    m.video_codec,
    m.video_format
FROM video_meta AS m
WHERE m.file_path = replace(p_file_path,'\','/');
$$;
