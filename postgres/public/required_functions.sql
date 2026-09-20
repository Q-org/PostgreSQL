-- 依赖扩展（幂等）
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS vector;
-- ============ 安全类型转换函数（幂等覆盖）============
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
-- ============ phash 转换函数（统一bit序，大小写兼容）============
-- hex -> vector64，增加lower统一大小写
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
-- hex -> bit64，和vector共用同一套get_bit顺序，保证bit/vector同源
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

-- vector64 -> hex，修复变量名 offset（PG关键字）改为 byte_offset

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

CREATE OR REPLACE FUNCTION public.phash_vector64_to_hex(v vector(64))
RETURNS text
LANGUAGE plpgsql IMMUTABLE STRICT PARALLEL SAFE AS $$
DECLARE
  v_str text;
  bits text[];
  out_hex text := '';
  byte_offset int;
  byte_val int;
  b int;
BEGIN
  v_str := v::text;
  v_str := replace(replace(v_str, '[', ''), ']', '');
  bits := string_to_array(v_str, ',');

  FOR byte_offset IN 0..7 LOOP
    byte_val := 0;
    FOR b IN 0..7 LOOP
      IF bits[byte_offset *8 + b + 1] = '1' THEN
        byte_val := byte_val | (1 << b);
      END IF;
    END LOOP;
    out_hex := out_hex || lpad(to_hex(byte_val), 2, '0');
  END LOOP;
  RETURN out_hex;
END;
$$;



-- ============ 汉明距离函数，增加STRICT，NULL入参直接返回NULL ============
CREATE OR REPLACE FUNCTION public.bit_hamming(a bit(64), b bit(64))
RETURNS int
IMMUTABLE STRICT LANGUAGE sql AS $$
SELECT length(replace((a # b)::text, '0', ''));
$$;
-- ============ 触发器函数 ============
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
-- ============ video_meta：新增字段（幂等）============
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='video_meta' AND column_name='status') THEN
    ALTER TABLE video_meta ADD COLUMN status TEXT NOT NULL DEFAULT 'pending';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='video_meta' AND column_name='processed_at') THEN
    ALTER TABLE video_meta ADD COLUMN processed_at TIMESTAMPTZ;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='video_meta' AND column_name='error_message') THEN
    ALTER TABLE video_meta ADD COLUMN error_message TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='video_meta' AND column_name='scene_count') THEN
    ALTER TABLE video_meta ADD COLUMN scene_count INT DEFAULT 0;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='video_meta' AND column_name='frame_count') THEN
    ALTER TABLE video_meta ADD COLUMN frame_count INT DEFAULT 0;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='video_meta' AND column_name='video_phash_hex') THEN
    ALTER TABLE video_meta ADD COLUMN video_phash_hex TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='video_meta' AND column_name='video_phash_vec') THEN
    ALTER TABLE video_meta ADD COLUMN video_phash_vec vector(64);
  END IF;
END $$;

-- video_meta 普通索引（无条件）
CREATE INDEX IF NOT EXISTS idx_video_meta_status ON video_meta(status);
CREATE INDEX IF NOT EXISTS idx_video_meta_processed_at ON video_meta(processed_at DESC);
-- video_meta HNSW索引：增加字段存在判断
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='video_meta' AND column_name='video_phash_vec') THEN
    CREATE INDEX IF NOT EXISTS idx_video_meta_phash_hnsw ON video_meta USING hnsw (video_phash_vec vector_l2_ops) WITH (m=32, ef_construction=128) WHERE video_phash_vec IS NOT NULL;
  END IF;
END $$;

DROP TRIGGER IF EXISTS trigger_video_meta_update ON video_meta;
CREATE TRIGGER trigger_video_meta_update
BEFORE UPDATE ON video_meta
FOR EACH ROW
EXECUTE FUNCTION public.set_update_time_at_meta();

-- ============ video_frames：新增 phash_hex + phash_bits + phash_vec 生成列 ============
DO $$
BEGIN
  -- 1. 新增独立phash_hex存储，脱离raw jsonb依赖
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='video_frames' AND column_name='phash_hex') THEN
    ALTER TABLE video_frames ADD COLUMN phash_hex TEXT;
  END IF;
  -- 2. phash_bits 生成列，使用统一函数 phash_hex_to_bit64，数据源改为 phash_hex
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='video_frames' AND column_name='phash_bits') THEN
    ALTER TABLE video_frames ADD COLUMN phash_bits bit(64) GENERATED ALWAYS AS (
      public.phash_hex_to_bit64(phash_hex)
    ) STORED;
  END IF;
  -- 3. 新增 phash_vec vector(64) 生成列，依赖 phash_hex
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='video_frames' AND column_name='phash_vec') THEN
    ALTER TABLE video_frames ADD COLUMN phash_vec vector(64) GENERATED ALWAYS AS (
      public.phash_hex_to_vector64(phash_hex)
    ) STORED;
  END IF;
END $$;

-- 存量数据回填 phash_hex（单独执行，业务低峰）
-- UPDATE video_frames SET phash_hex = raw->>'phash' WHERE phash_hex IS NULL;

-- video_frames 索引块：全部字段存在校验，修复batch_id/workflow_id不存在报错
DO $$
BEGIN
  -- video_id, idx 联合索引，假设这两个字段一定存在
  CREATE INDEX IF NOT EXISTS idx_video_frames_vid_idx ON video_frames(video_id, idx);

  -- batch_id 索引，存在才建
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='video_frames' AND column_name='batch_id') THEN
    CREATE INDEX IF NOT EXISTS idx_video_frames_batch_id ON video_frames(batch_id) WHERE batch_id IS NOT NULL;
  END IF;

  -- workflow_id 索引，存在才建
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='video_frames' AND column_name='workflow_id') THEN
    CREATE INDEX IF NOT EXISTS idx_video_frames_workflow_id ON video_frames(workflow_id) WHERE workflow_id IS NOT NULL;
  END IF;

  -- phash相关索引：存在phash_vec才建
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='video_frames' AND column_name='phash_vec') THEN
    CREATE INDEX IF NOT EXISTS idx_video_frames_phash_hnsw
    ON video_frames USING hnsw (phash_vec vector_l2_ops)
    WITH (m = 32, ef_construction = 128)
    WHERE phash_vec IS NOT NULL;
    CREATE INDEX IF NOT EXISTS idx_video_frames_phash_exact ON video_frames(phash_vec) WHERE phash_vec IS NOT NULL;
  END IF;
END $$;

DROP TRIGGER IF EXISTS trigger_video_frames_update ON video_frames;
CREATE TRIGGER trigger_video_frames_update
BEFORE UPDATE ON video_frames
FOR EACH ROW
EXECUTE FUNCTION public.set_update_time_at();

-- ============ 校验脚本（执行完DDL + 回填phash_hex后运行） ============
/*
SELECT
  'bd64a8e285f54680' AS original,
  phash_vector64_to_hex(phash_hex_to_vector64('bd64a8e285f54680')) AS roundtrip;

SELECT phash_hex, public.phash_vector64_to_hex(phash_vec), phash_bits
FROM video_frames
LIMIT 100;
*/
