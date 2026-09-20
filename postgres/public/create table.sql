-- =============================================
-- 【危险】删除表，CASCADE 自动清理触发器/约束依赖
-- =============================================
DROP TABLE IF EXISTS public.video_frames CASCADE;
DROP TABLE IF EXISTS public.video_meta CASCADE;

-- =============================================
-- 依赖扩展
-- =============================================
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS vector;

-- =============================================
-- 安全类型转换函数
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
-- phash 转换函数（hex ↔ vector 往返可逆）
-- =============================================
-- hex -> vector64
CREATE OR REPLACE FUNCTION public.phash_hex_to_vector64(hex_str text)
RETURNS vector(64)
LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE AS $$
SELECT
  ('[' ||
   array_to_string(
     ARRAY(
       SELECT get_bit(decode(lower(hex_str), 'hex'), i)
       FROM generate_series(0, 63) AS i
     ),
     ','
   ) || ']'
  )::vector(64)
WHERE hex_str ~ '^[0-9a-fA-F]{16}$';
$$;

-- hex -> bit64，和vector共用同一套get_bit顺序
CREATE OR REPLACE FUNCTION public.phash_hex_to_bit64(hex text)
RETURNS bit(64)
LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE AS $$
SELECT (
  string_agg(
    get_bit(decode(lower(hex),'hex'),i)::text, '' ORDER BY i
  )
)::bit(64)
FROM generate_series(0,63) i
WHERE hex ~ '^[0-9a-fA-F]{16}$';
$$;

-- vector64 -> hex
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
END;
$$;

-- 汉明距离函数 PG16+
CREATE OR REPLACE FUNCTION public.bit_hamming(a bit(64), b bit(64))
RETURNS int
IMMUTABLE STRICT LANGUAGE sql AS $$
SELECT bit_count(a # b);
$$;
-- PG15及以下替换上面函数为：
-- CREATE OR REPLACE FUNCTION public.bit_hamming(a bit(64), b bit(64))
-- RETURNS int
-- IMMUTABLE STRICT LANGUAGE sql AS $$
-- SELECT length(replace((a # b)::text, '0', ''));
-- $$;

-- =============================================
-- 触发器函数
-- =============================================
CREATE OR REPLACE FUNCTION public.set_update_time_at()
RETURNS TRIGGER AS $$
BEGIN
  IF (
       NEW.raw          IS DISTINCT FROM OLD.raw
    OR NEW.video_id     IS DISTINCT FROM OLD.video_id
    OR NEW.pts_time     IS DISTINCT FROM OLD.pts_time
    OR NEW.idx          IS DISTINCT FROM OLD.idx
    OR NEW.phash_hex    IS DISTINCT FROM OLD.phash_hex
    OR NEW.phash_bits   IS DISTINCT FROM OLD.phash_bits
    OR NEW.phash_vec    IS DISTINCT FROM OLD.phash_vec
  ) THEN
    NEW.update_time_at = NOW();
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.set_update_time_at_meta()
RETURNS TRIGGER AS $$
BEGIN
  IF (
       NEW.raw          IS DISTINCT FROM OLD.raw
    OR NEW.is_valid      IS DISTINCT FROM OLD.is_valid
    OR NEW.last_modified IS DISTINCT FROM OLD.last_modified
    OR NEW.status        IS DISTINCT FROM OLD.status
    OR NEW.processed_at  IS DISTINCT FROM OLD.processed_at
    OR NEW.scene_count   IS DISTINCT FROM OLD.scene_count
    OR NEW.frame_count   IS DISTINCT FROM OLD.frame_count
    OR NEW.error_message IS DISTINCT FROM OLD.error_message
    OR NEW.video_phash_hex IS DISTINCT FROM OLD.video_phash_hex
    OR NEW.video_phash_vec IS DISTINCT FROM OLD.video_phash_vec
  ) THEN
    NEW.update_time_at = NOW();
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- 重建表（修正：删除重复 raw 字段！！你上一版脚本有重复 raw jsonb NOT NULL）
-- =============================================
CREATE TABLE "public"."video_meta" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "raw" jsonb NOT NULL,
  "file_path" text GENERATED ALWAYS AS (
    ((raw -> 'fileInfo'::text) ->> 'filePath'::text)
  ) STORED,
  "file_hash" text GENERATED ALWAYS AS (
    (raw ->> 'file_hash'::text)
  ) STORED,
  "create_time_at" timestamptz(6) NOT NULL DEFAULT now(),
  "update_time_at" timestamptz(6) NOT NULL DEFAULT now(),
  "last_modified" timestamptz(6),
  "is_valid" bool DEFAULT true,
  "status" text NOT NULL DEFAULT 'pending'::text,
  "processed_at" timestamptz(6),
  "error_message" text,
  "scene_count" int4 DEFAULT 0,
  "frame_count" int4 DEFAULT 0,
  "video_phash_hex" text,
  "video_phash_vec" vector(64),
  PRIMARY KEY ("id"),
  UNIQUE ("file_path")
);

CREATE TABLE "public"."video_frames" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "video_id" uuid NOT NULL,
  "raw" jsonb NOT NULL,
  "phash_hex" text GENERATED ALWAYS AS (raw ->> 'phash') STORED,
  "phash_bits" bit(64) GENERATED ALWAYS AS (
    public.phash_hex_to_bit64(raw ->> 'phash')
  ) STORED,
  "phash_vec" vector(64) GENERATED ALWAYS AS (
    public.phash_hex_to_vector64(raw ->> 'phash')
  ) STORED,
  "frame_type" text GENERATED ALWAYS AS (
    (raw ->> 'frameType'::text)
  ) STORED,
  "workflow_id" text GENERATED ALWAYS AS (
    (raw ->> 'workflowId'::text)
  ) STORED,
  -- ========== 新增普通字段（非生成列，手动填写） ==========
  "review_status" text,
  "review_comment" text,
  -- ========================================================
  "pts_time" numeric(12,6) NOT NULL,
  "idx" int4 NOT NULL,
  "create_time_at" timestamptz(6) NOT NULL DEFAULT now(),
  "update_time_at" timestamptz(6) NOT NULL DEFAULT now(),
  PRIMARY KEY ("id"),
  FOREIGN KEY ("video_id") REFERENCES "public"."video_meta" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
  UNIQUE ("video_id", "idx"),
  CHECK (pts_time >= 0::numeric),
  CHECK (idx >= 0)
);

-- =============================================
-- 创建索引
-- =============================================
-- video_meta
CREATE INDEX idx_video_meta_file_hash ON video_meta(file_hash);
CREATE INDEX idx_video_meta_is_valid ON video_meta(is_valid);
CREATE INDEX idx_video_meta_status ON video_meta(status);
CREATE INDEX idx_video_meta_processed_at ON video_meta(processed_at DESC);
CREATE INDEX idx_video_meta_phash_hnsw ON video_meta USING hnsw (video_phash_vec vector_l2_ops) WHERE video_phash_vec IS NOT NULL;

-- video_frames
CREATE INDEX idx_video_frames_frame_type ON video_frames(frame_type);
CREATE INDEX idx_video_frames_workflow_id ON video_frames(workflow_id) WHERE workflow_id IS NOT NULL;
CREATE INDEX idx_video_frames_vid_idx ON video_frames(video_id, idx);
CREATE INDEX idx_video_frames_vid_pts ON video_frames(video_id, pts_time);
CREATE INDEX idx_video_frames_phash_hnsw ON video_frames USING hnsw (phash_vec vector_l2_ops) WITH (m = 32, ef_construction = 128) WHERE phash_vec IS NOT NULL;
CREATE INDEX idx_video_frames_phash_exact ON video_frames(phash_vec) WHERE phash_vec IS NOT NULL;

-- =============================================
-- 创建触发器
-- =============================================
CREATE TRIGGER trigger_video_meta_update
BEFORE UPDATE ON video_meta
FOR EACH ROW
EXECUTE FUNCTION public.set_update_time_at_meta();

CREATE TRIGGER trigger_video_frames_update
BEFORE UPDATE ON video_frames
FOR EACH ROW
EXECUTE FUNCTION public.set_update_time_at();

-- =============================================
-- 存量回填（新库不需要，保留注释）
-- =============================================
-- UPDATE video_frames SET phash_hex = raw->>'phash' WHERE phash_hex IS NULL;

-- =============================================
-- 校验SQL
-- =============================================
/*
SELECT
  'bd64a8e285f54680' AS original,
  public.phash_vector64_to_hex(public.phash_hex_to_vector64('bd64a8e285f54680')) AS roundtrip;

SELECT phash_hex, public.phash_vector64_to_hex(phash_vec), phash_bits
FROM video_frames
LIMIT 100;
*/
