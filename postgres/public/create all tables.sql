DROP FUNCTION IF EXISTS public.get_video_frame_info(uuid,numeric);
CREATE OR REPLACE FUNCTION get_video_frame_info(
    p_video_id uuid,
    p_fps numeric DEFAULT 1
)
RETURNS TABLE (
    frame_count bigint,
    real_frame_count bigint,
    status text
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_video_duration numeric;
BEGIN
    -- 从video_meta读取生成列 video_duration
    SELECT video_duration INTO v_video_duration
    FROM video_meta
    WHERE id = p_video_id;

    IF NOT FOUND THEN
        RETURN QUERY SELECT 0::bigint,0::bigint,'NotFound'::text;
        RETURN;
    END IF;

    RETURN QUERY
    SELECT
        FLOOR(COALESCE(v_video_duration,0) * p_fps)::bigint AS frame_count,
        COUNT(CASE WHEN a.pts_time IS NOT NULL THEN a.id END)::bigint AS real_frame_count,
        CASE
            WHEN NOT EXISTS (SELECT 1 FROM video_frames x WHERE x.video_id = p_video_id AND x.has_image = true)
                THEN 'Run'
            WHEN FLOOR(COALESCE(v_video_duration,0) * p_fps) = COUNT(CASE WHEN a.pts_time IS NOT NULL THEN a.id END)
                THEN 'Skip'
            ELSE 'Run'
        END AS status
    FROM video_frames AS a
    WHERE a.video_id = p_video_id;
END;
$$;

-- =============================================
-- 【危险】删除表，CASCADE 自动清理触发器/约束依赖
-- =============================================
DROP TABLE IF EXISTS public.frame_edge CASCADE;
DROP TABLE IF EXISTS public.loop_frames_result CASCADE;
DROP TABLE IF EXISTS public.video_process_stage CASCADE;
DROP TABLE IF EXISTS public.video_frames CASCADE;
DROP TABLE IF EXISTS public.video_meta CASCADE;
DROP TABLE IF EXISTS public.review_risk CASCADE;

DROP TRIGGER IF EXISTS trg_video_meta_update ON video_meta;
DROP TRIGGER IF EXISTS trg_video_frames_update ON video_frames;

-- =============================================
-- 依赖扩展
-- =============================================
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS vector;

-- =============================================
-- 安全类型转换函数 全部 PARALLEL SAFE
-- =============================================
CREATE OR REPLACE FUNCTION public.to_timestamptz(input_str text)
RETURNS timestamptz
LANGUAGE plpgsql IMMUTABLE STRICT PARALLEL SAFE AS $$
BEGIN
  IF btrim(input_str) = '' THEN RETURN NULL; END IF;
  RETURN btrim(input_str)::timestamptz;
EXCEPTION WHEN OTHERS THEN RETURN NULL;
END;
$$;

CREATE OR REPLACE FUNCTION public.to_numeric(input_str text)
RETURNS numeric
LANGUAGE plpgsql IMMUTABLE STRICT PARALLEL SAFE AS $$
BEGIN
  IF btrim(input_str) = '' THEN RETURN NULL; END IF;
  RETURN btrim(input_str)::numeric;
EXCEPTION WHEN OTHERS THEN RETURN NULL;
END;
$$;

CREATE OR REPLACE FUNCTION public.to_int(input_str text)
RETURNS int
LANGUAGE plpgsql IMMUTABLE STRICT PARALLEL SAFE AS $$
BEGIN
  IF btrim(input_str) = '' THEN RETURN NULL; END IF;
  RETURN btrim(input_str)::int;
EXCEPTION WHEN OTHERS THEN RETURN NULL;
END;
$$;

CREATE OR REPLACE FUNCTION public.to_bigint(input_str text)
RETURNS bigint
LANGUAGE plpgsql IMMUTABLE STRICT PARALLEL SAFE AS $$
BEGIN
  IF btrim(input_str) = '' THEN RETURN NULL; END IF;
  RETURN btrim(input_str)::bigint;
EXCEPTION WHEN OTHERS THEN RETURN NULL;
END;
$$;

CREATE OR REPLACE FUNCTION public.to_uuid(input_str text)
RETURNS uuid
LANGUAGE plpgsql IMMUTABLE STRICT PARALLEL SAFE AS $$
BEGIN
  IF btrim(input_str) = '' THEN RETURN NULL; END IF;
  RETURN btrim(input_str)::uuid;
EXCEPTION WHEN OTHERS THEN RETURN NULL;
END;
$$;

-- =============================================
-- phash 转换函数（hex ↔ vector 往返可逆，增加异常保护）
-- =============================================
CREATE OR REPLACE FUNCTION public.phash_hex_to_vector64(hex_str text)
RETURNS vector(64)
LANGUAGE plpgsql IMMUTABLE STRICT PARALLEL SAFE AS $$
BEGIN
  IF hex_str !~ '^[0-9a-fA-F]{16}$' THEN
    RETURN NULL;
  END IF;
  RETURN (
    '[' ||
    array_to_string(
      ARRAY(
        SELECT get_bit(decode(lower(hex_str), 'hex'), i)
        FROM generate_series(0, 63) AS i
      ),
      ','
    ) || ']'
  )::vector(64);
EXCEPTION WHEN OTHERS THEN RETURN NULL;
END;
$$;

CREATE OR REPLACE FUNCTION public.phash_hex_to_bit64(hex text)
RETURNS bit(64)
LANGUAGE plpgsql IMMUTABLE STRICT PARALLEL SAFE AS $$
BEGIN
  IF hex !~ '^[0-9a-fA-F]{16}$' THEN
    RETURN NULL;
  END IF;
  RETURN (
    string_agg(
      get_bit(decode(lower(hex),'hex'),i)::text, '' ORDER BY i
    )
  )::bit(64)
  FROM generate_series(0,63) i;
EXCEPTION WHEN OTHERS THEN RETURN NULL;
END;
$$;

CREATE OR REPLACE FUNCTION public.phash_vector64_to_hex(v vector(64))
RETURNS text
LANGUAGE plpgsql IMMUTABLE STRICT PARALLEL SAFE AS $$
DECLARE
  out_hex text := '';
  byte_offset int;
  bit_val int;
  byte_val int;
  bit_idx int;
BEGIN
  FOR byte_offset IN 0..7 LOOP
    byte_val := 0;
    FOR bit_idx IN 0..7 LOOP
      bit_val := (v[byte_offset*8 + bit_idx])::int;
      IF bit_val = 1 THEN
        byte_val := byte_val | (1 << (7 - bit_idx));
      END IF;
    END LOOP;
    out_hex := out_hex || lpad(to_hex(byte_val),2,'0');
  END LOOP;
  RETURN out_hex;
EXCEPTION WHEN OTHERS THEN RETURN NULL;
END;
$$;

-- PG16+ 汉明距离
CREATE OR REPLACE FUNCTION public.bit_hamming(a bit(64), b bit(64))
RETURNS int
IMMUTABLE STRICT PARALLEL SAFE LANGUAGE sql AS $$
SELECT bit_count(a # b);
$$;

-- PG15及以下请注释上面，启用下面
/*
CREATE OR REPLACE FUNCTION public.bit_hamming(a bit(64), b bit(64))
RETURNS int
IMMUTABLE STRICT PARALLEL SAFE LANGUAGE sql AS $$
SELECT length(replace((a # b)::text, '0', ''));
$$;
*/

-- =============================================
-- 更新时间触发器函数 + 绑定触发器
-- =============================================
CREATE OR REPLACE FUNCTION public.set_update_time_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    NEW.update_time_at := NOW();
    RETURN NEW;
END;
$$;

-- ===================== video_meta =====================
CREATE TABLE "public"."video_meta" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "raw" jsonb NOT NULL,
  "file_hash" text,
  "is_valid" boolean NOT NULL DEFAULT true,

  "file_path" text GENERATED ALWAYS AS (raw #>> '{fileInfo,filePath}') STORED,
  "video_fps" numeric GENERATED ALWAYS AS (public.to_numeric(raw #>> '{videoInfo,fps}')) STORED,
  "duration" numeric GENERATED ALWAYS AS (public.to_numeric(raw #>> '{videoInfo,duration}')) STORED,
  "video_width" int4 GENERATED ALWAYS AS (public.to_int(raw #>> '{videoInfo,width}')) STORED,
  "video_height" int4 GENERATED ALWAYS AS (public.to_int(raw #>> '{videoInfo,height}')) STORED,

  "video_phash_hex" text GENERATED ALWAYS AS (raw ->> 'videoPhash') STORED,
  "video_phash_vec" vector(64) GENERATED ALWAYS AS (public.phash_hex_to_vector64(raw ->> 'videoPhash')) STORED,
  "file_name" text GENERATED ALWAYS AS (raw #>> '{fileInfo,fileName}') STORED,
  "file_size" bigint GENERATED ALWAYS AS (public.to_bigint(raw #>> '{fileInfo,fileSize}')) STORED,

  "video_codec" text GENERATED ALWAYS AS (raw #>> '{videoInfo,codec}') STORED,

  "video_format" text GENERATED ALWAYS AS (raw #>> '{videoInfo,format}') STORED,
  "mtime_at" timestamptz(6) GENERATED ALWAYS AS (public.to_timestamptz(raw #>> '{fileInfo,mtime}')) STORED,
  "atime_at" timestamptz(6) GENERATED ALWAYS AS (public.to_timestamptz(raw #>> '{fileInfo,atime}')) STORED,

  "create_time_at" timestamptz(6) NOT NULL DEFAULT now(),
  "update_time_at" timestamptz(6) NOT NULL DEFAULT now(),
  "last_modified" timestamptz(6),
  "status" text,
  "processed_at" timestamptz(6),
  "error_message" text,

  PRIMARY KEY ("id")
);

-- 触发器绑定
CREATE TRIGGER trg_video_meta_update
BEFORE UPDATE ON video_meta
FOR EACH ROW EXECUTE FUNCTION public.set_update_time_at();

COMMENT ON COLUMN video_meta.duration IS '视频总时长(秒)，生成列，取自raw.videoInfo.duration';

CREATE UNIQUE INDEX IF NOT EXISTS idx_video_meta_file_hash ON public.video_meta(file_hash);
CREATE INDEX IF NOT EXISTS idx_video_meta_file_name ON public.video_meta(file_name);
CREATE INDEX IF NOT EXISTS idx_video_meta_video_size ON public.video_meta(video_width,video_height);
CREATE INDEX IF NOT EXISTS idx_video_meta_duration ON public.video_meta(duration);
CREATE INDEX IF NOT EXISTS idx_video_meta_is_valid ON public.video_meta(is_valid);
CREATE INDEX IF NOT EXISTS idx_video_meta_status ON public.video_meta(status);
CREATE INDEX IF NOT EXISTS idx_video_meta_processed_at ON public.video_meta(processed_at DESC);
CREATE INDEX IF NOT EXISTS idx_video_meta_phash_hnsw ON video_meta USING hnsw (video_phash_vec vector_l2_ops) WHERE video_phash_vec IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS idx_video_meta_file_path ON public.video_meta(file_path);

-- ===================== review_risk =====================
CREATE TABLE public.review_risk (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    risk_code text NOT NULL UNIQUE,
    risk_name text NOT NULL,
    risk_level int NOT NULL,
    description text,
    is_active boolean NOT NULL DEFAULT true,
    create_at timestamptz(6) NOT NULL DEFAULT now(),
    update_at timestamptz(6) NOT NULL DEFAULT now(),
    PRIMARY KEY(id)
);

INSERT INTO public.review_risk(risk_code, risk_name, risk_level, description)
VALUES
('vulgar','低俗',2,'低俗画面、不雅动作'),
('nudity','露点',1,'裸露、露点画面'),
('bad_tendency','不良倾向',2,'不良价值观、不良导向'),
('violence','暴力',1,'血腥暴力画面');

-- ===================== video_frames 子表 =====================
CREATE TABLE "public"."video_frames" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "video_id" uuid NOT NULL,
  "raw" jsonb NOT NULL,

  "phash_hex" text GENERATED ALWAYS AS (raw ->> 'phash') STORED,
  "phash_bits" bit(64) GENERATED ALWAYS AS (public.phash_hex_to_bit64(raw ->> 'phash')) STORED,
  "phash_vec" vector(64) GENERATED ALWAYS AS (public.phash_hex_to_vector64(raw ->> 'phash')) STORED,
  "frame_type" text GENERATED ALWAYS AS (raw ->> 'frameType') STORED,
  "workflow_id" text GENERATED ALWAYS AS (raw ->> 'workflowId') STORED,
  "fps" numeric GENERATED ALWAYS AS (public.to_numeric(raw ->> 'fps')) STORED,
  "dhash" text GENERATED ALWAYS AS (raw ->> 'dhash') STORED,
  "imagePath" text GENERATED ALWAYS AS (raw ->> 'imagePath') STORED,
  "gopSampleType" text GENERATED ALWAYS AS (raw ->> 'gopSampleType') STORED,
  "duration" numeric GENERATED ALWAYS AS (public.to_numeric(raw #>> '{videoInfo,duration}')) STORED,

  "has_image" boolean,
  "review_status" text,
  "review_comment" text,
  "img_url" text,
  "risk_ids" uuid[],
  "pts_time" numeric NOT NULL,
  "idx" bigint NOT NULL,
  "create_time_at" timestamptz(6) NOT NULL DEFAULT now(),
  "update_time_at" timestamptz(6) NOT NULL DEFAULT now(),

  PRIMARY KEY ("id"),
  FOREIGN KEY ("video_id") REFERENCES "public"."video_meta" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
  UNIQUE ("video_id", "idx"),
  CONSTRAINT uq_video_frames_vid_pts UNIQUE (video_id, pts_time),
  CHECK (pts_time >= 0),
  CHECK (idx >= 0),
  CHECK ("fps" IS NULL OR "fps" >= 0)
);

CREATE TRIGGER trg_video_frames_update
BEFORE UPDATE ON video_frames
FOR EACH ROW EXECUTE FUNCTION public.set_update_time_at();

COMMENT ON COLUMN public.video_frames.duration IS '视频总时长(秒),来自raw.videoInfo.duration';

-- 索引
CREATE INDEX IF NOT EXISTS idx_video_frames_frame_type ON video_frames(frame_type);
CREATE INDEX IF NOT EXISTS idx_video_frames_vid_idx ON video_frames(video_id, idx);
CREATE INDEX IF NOT EXISTS idx_video_frames_vid_pts ON video_frames(video_id, pts_time);
CREATE INDEX IF NOT EXISTS idx_video_frames_vid_fps ON public.video_frames(video_id, fps);
CREATE INDEX IF NOT EXISTS idx_video_frames_has_image ON video_frames(has_image);
CREATE INDEX IF NOT EXISTS idx_video_frames_review_status ON video_frames(review_status);
CREATE INDEX IF NOT EXISTS idx_video_frames_phash_hnsw ON video_frames USING hnsw (phash_vec vector_l2_ops) WITH (m = 32, ef_construction = 128) WHERE phash_vec IS NOT NULL;

-- ===================== video_process_stage =====================
-- CREATE TABLE video_process_stage (
--     id uuid NOT NULL DEFAULT gen_random_uuid(),
--     video_id UUID NOT NULL,
--     stage VARCHAR(30) NOT NULL,
--     status VARCHAR(20) NOT NULL,
--     progress NUMERIC(5,4) DEFAULT 0,
--     error_message TEXT,
--     started_at TIMESTAMPTZ,
--     completed_at TIMESTAMPTZ,
--     updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
--     create_at timestamptz(6) NOT NULL DEFAULT now(),
--     PRIMARY KEY(id),
--     CONSTRAINT uq_video_process_stage UNIQUE (video_id, stage),
--     FOREIGN KEY(video_id) REFERENCES video_meta(id) ON DELETE CASCADE
-- );
-- 
-- CREATE INDEX idx_video_process_stage_vid ON video_process_stage(video_id);

-- ===================== loop_frames_result =====================
-- =====================================================
-- 1. 修改表结构：移除pts复合外键，改用video_frames.id(uuid)外键
-- =====================================================
DROP TABLE IF EXISTS loop_frames_result;

DROP TABLE IF EXISTS loop_frames_result;

CREATE TABLE loop_frames_result
(
    id uuid PRIMARY KEY, -- 直接引用 video_frames.id，本表主键，不自增
    video_id uuid NOT NULL,
    frame_pts numeric NOT NULL,
    similar_pts numeric,
    distance int,
    last_distance int,
    created_at timestamptz DEFAULT now(),

    similar_frame_id uuid,

    -- 主键外键：本表id 关联 video_frames.id，级联删除
    CONSTRAINT fk_loop_result_frame_id
        FOREIGN KEY (id) REFERENCES video_frames(id) ON DELETE CASCADE,

    -- 相似帧外键
    CONSTRAINT fk_loop_result_similar_frame_id
        FOREIGN KEY (similar_frame_id) REFERENCES video_frames(id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_loop_frames_result_video ON loop_frames_result(video_id);
CREATE INDEX IF NOT EXISTS idx_loop_frames_result_similar_frame ON loop_frames_result(similar_frame_id);

-- ===================== frame_edge 修复：主键不能包含可空字段 =====================
CREATE TABLE frame_edge (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    video_id uuid NOT NULL,
    a_real_pts numeric,
    a_virt_idx bigint,
    b_real_pts numeric,
    b_virt_idx bigint,
    distance smallint NOT NULL,
    create_at timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT chk_a_end CHECK (
        (a_real_pts IS NOT NULL AND a_virt_idx IS NULL)
        OR
        (a_real_pts IS NULL AND a_virt_idx IS NOT NULL)
    ),
    CONSTRAINT chk_b_end CHECK (
        (b_real_pts IS NOT NULL AND b_virt_idx IS NULL)
        OR
        (b_real_pts IS NULL AND b_virt_idx IS NOT NULL)
    ),
    CONSTRAINT fk_edge_a_real
        FOREIGN KEY (video_id, a_real_pts)
        REFERENCES video_frames (video_id, pts_time)
        ON DELETE CASCADE,
    CONSTRAINT fk_edge_b_real
        FOREIGN KEY (video_id, b_real_pts)
        REFERENCES video_frames (video_id, pts_time)
        ON DELETE CASCADE
);

COMMENT ON TABLE frame_edge IS
'帧相似度边；支持4种组合：真实帧<->真实帧｜真实帧<->虚拟插值帧｜虚拟插值帧<->真实帧｜虚拟插值帧<->虚拟插值帧；
real_pts不为NULL代表DB已入库I关键帧；virt_idx不为NULL代表内存生成未入库虚拟插值帧；
真实帧端点会做外键级联删除；虚拟帧无外键；同一端点real_pts/virt_idx互斥';
COMMENT ON COLUMN frame_edge.a_real_pts IS 'A端：真实帧pts_time，虚拟帧为NULL';
COMMENT ON COLUMN frame_edge.a_virt_idx IS 'A端：虚拟帧内存idx，真实帧为NULL';
COMMENT ON COLUMN frame_edge.b_real_pts IS 'B端：真实帧pts_time，虚拟帧为NULL';
COMMENT ON COLUMN frame_edge.b_virt_idx IS 'B端：虚拟帧内存idx，真实帧为NULL';
COMMENT ON COLUMN frame_edge.distance IS 'phash汉明距离 0~64';

CREATE INDEX idx_frame_edge_video ON frame_edge(video_id);
CREATE INDEX idx_frame_edge_a_real ON frame_edge(video_id, a_real_pts) WHERE a_real_pts IS NOT NULL;
CREATE INDEX idx_frame_edge_b_real ON frame_edge(video_id, b_real_pts) WHERE b_real_pts IS NOT NULL;
CREATE INDEX idx_frame_edge_a_virt ON frame_edge(video_id, a_virt_idx) WHERE a_virt_idx IS NOT NULL;
CREATE INDEX idx_frame_edge_b_virt ON frame_edge(video_id, b_virt_idx) WHERE b_virt_idx IS NOT NULL;

