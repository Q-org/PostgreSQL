-- =============================================
-- Video Processing Platform - 补充表脚本【优化审核版】
-- 基于原有6张基础表，新增6张扩展表，用于Phase2迭代
-- 新增：raw jsonb + 可计算字段改为 GENERATED STORED 生成列
-- ⚠️ 前提：Phase1 6表已创建，包含 set_update_time_at 触发器函数
-- =============================================
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS vector;

-- =============================================
-- 1. asset（媒体资产表）- 核心抽象
-- =============================================
CREATE TABLE IF NOT EXISTS "public"."asset" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "raw" jsonb NOT NULL, -- 原始完整快照
  "type" varchar(20) NOT NULL GENERATED ALWAYS AS (raw ->> 'type') STORED,
  "storage_key" text NOT NULL GENERATED ALWAYS AS (raw ->> 'storage_key') STORED,
  "file_hash" varchar(64) GENERATED ALWAYS AS (raw ->> 'file_hash') STORED,
  "metadata" jsonb GENERATED ALWAYS AS (raw -> 'metadata') STORED,
  "create_time_at" timestamptz(6) NOT NULL DEFAULT now(),
  "update_time_at" timestamptz(6) NOT NULL DEFAULT now(),
  PRIMARY KEY ("id")
);
CREATE INDEX IF NOT EXISTS idx_asset_type ON asset(type);
CREATE INDEX IF NOT EXISTS idx_asset_hash ON asset(file_hash);
CREATE INDEX IF NOT EXISTS idx_asset_raw_gin ON asset USING gin(raw);
COMMENT ON TABLE "public"."asset" IS '媒体资产表，统一管理视频、图片、音频等资源';

-- 触发器
CREATE TRIGGER trigger_asset_update
BEFORE UPDATE ON asset
FOR EACH ROW
EXECUTE FUNCTION public.set_update_time_at();

-- =============================================
-- 2. analysis_result（分析结果统一表）- 核心抽象
-- =============================================
CREATE TABLE IF NOT EXISTS "public"."analysis_result" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "raw" jsonb NOT NULL, -- 原始完整快照
  "asset_id" uuid NOT NULL GENERATED ALWAYS AS ((raw ->> 'asset_id')::uuid) STORED REFERENCES "public"."asset"("id") ON DELETE CASCADE,
  "frame_idx" int4 GENERATED ALWAYS AS ((raw ->> 'frame_idx')::int4) STORED,
  "analysis_type" varchar(50) NOT NULL GENERATED ALWAYS AS (raw ->> 'analysis_type') STORED,
  "result" jsonb NOT NULL GENERATED ALWAYS AS (raw -> 'result') STORED,
  "model_name" varchar(100) GENERATED ALWAYS AS (raw ->> 'model_name') STORED,
  "model_version" varchar(20) GENERATED ALWAYS AS (raw ->> 'model_version') STORED,
  "confidence" numeric(5,4) GENERATED ALWAYS AS ((raw ->> 'confidence')::numeric(5,4)) STORED,
  "create_time_at" timestamptz(6) NOT NULL DEFAULT now(),
  PRIMARY KEY ("id"),
  CONSTRAINT chk_analysis_confidence CHECK (confidence BETWEEN 0 AND 1)
);
CREATE INDEX IF NOT EXISTS idx_analysis_asset ON analysis_result(asset_id);
CREATE INDEX IF NOT EXISTS idx_analysis_type ON analysis_result(analysis_type);
CREATE INDEX IF NOT EXISTS idx_analysis_frame ON analysis_result(asset_id, frame_idx);
CREATE INDEX IF NOT EXISTS idx_analysis_result_gin ON analysis_result USING gin(result);
CREATE INDEX IF NOT EXISTS idx_analysis_raw_gin ON analysis_result USING gin(raw);
COMMENT ON TABLE "public"."analysis_result" IS '分析结果统一表，支持多种 AI 能力的灵活扩展';

-- 无update_time_at，不需要触发器（仅插入，不更新）

-- =============================================
-- 3. video_segment（视频分段表）
-- =============================================
CREATE TABLE IF NOT EXISTS "public"."video_segment" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "raw" jsonb NOT NULL, -- 原始完整快照
  "video_id" uuid NOT NULL GENERATED ALWAYS AS ((raw ->> 'video_id')::uuid) STORED REFERENCES "public"."video_meta"("id") ON DELETE CASCADE,
  "start_time" numeric(12,6) NOT NULL GENERATED ALWAYS AS ((raw ->> 'start_time')::numeric(12,6)) STORED,
  "end_time" numeric(12,6) NOT NULL GENERATED ALWAYS AS ((raw ->> 'end_time')::numeric(12,6)) STORED,
  "segment_type" varchar(20) NOT NULL GENERATED ALWAYS AS (raw ->> 'segment_type') STORED,
  "confidence" numeric(5,4) GENERATED ALWAYS AS ((raw ->> 'confidence')::numeric(5,4)) STORED,
  "metadata" jsonb GENERATED ALWAYS AS (raw -> 'metadata') STORED,
  "create_time_at" timestamptz(6) NOT NULL DEFAULT now(),
  "update_time_at" timestamptz(6) NOT NULL DEFAULT now(),
  PRIMARY KEY ("id"),
  CONSTRAINT chk_segment_confidence CHECK (confidence BETWEEN 0 AND 1),
  CONSTRAINT chk_segment_time CHECK (end_time >= start_time AND start_time >= 0)
);
CREATE INDEX IF NOT EXISTS idx_segment_video_id ON video_segment(video_id);
CREATE INDEX IF NOT EXISTS idx_segment_time ON video_segment(video_id, start_time, end_time);
CREATE INDEX IF NOT EXISTS idx_segment_type ON video_segment(segment_type);
CREATE INDEX IF NOT EXISTS idx_segment_raw_gin ON video_segment USING gin(raw);
COMMENT ON TABLE "public"."video_segment" IS '视频分段表，用于场景检测和章节划分';

CREATE TRIGGER trigger_video_segment_update
BEFORE UPDATE ON video_segment
FOR EACH ROW
EXECUTE FUNCTION public.set_update_time_at();

-- =============================================
-- 4. ocr_result（OCR 结果表）
-- =============================================
CREATE TABLE IF NOT EXISTS "public"."ocr_result" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "raw" jsonb NOT NULL, -- 原始完整快照
  "video_id" uuid NOT NULL GENERATED ALWAYS AS ((raw ->> 'video_id')::uuid) STORED REFERENCES "public"."video_meta"("id") ON DELETE CASCADE,
  "frame_idx" int4 NOT NULL GENERATED ALWAYS AS ((raw ->> 'frame_idx')::int4) STORED,
  "region_hash" varchar(8) GENERATED ALWAYS AS (raw ->> 'region_hash') STORED,
  "text" text NOT NULL GENERATED ALWAYS AS (raw ->> 'text') STORED,
  "confidence" numeric(5,4) GENERATED ALWAYS AS ((raw ->> 'confidence')::numeric(5,4)) STORED,
  "bounding_box" jsonb GENERATED ALWAYS AS (raw -> 'bounding_box') STORED,
  "language" varchar(10) GENERATED ALWAYS AS (coalesce(raw ->> 'language','eng')) STORED,
  "create_time_at" timestamptz(6) NOT NULL DEFAULT now(),
  PRIMARY KEY ("id"),
  CONSTRAINT chk_ocr_confidence CHECK (confidence BETWEEN 0 AND 1)
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_ocr_unique ON ocr_result(video_id, frame_idx, region_hash);
CREATE INDEX IF NOT EXISTS idx_ocr_video_id ON ocr_result(video_id);
CREATE INDEX IF NOT EXISTS idx_ocr_text_gin ON ocr_result USING gin(to_tsvector('simple', text));
CREATE INDEX IF NOT EXISTS idx_ocr_raw_gin ON ocr_result USING gin(raw);
COMMENT ON TABLE "public"."ocr_result" IS 'OCR 文字识别结果表，支持全文搜索';

-- 仅插入，不更新，无update触发器

-- =============================================
-- 5. face_detection（人脸检测表）
-- =============================================
CREATE TABLE IF NOT EXISTS "public"."face_detection" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "raw" jsonb NOT NULL, -- 原始完整快照
  "video_id" uuid NOT NULL GENERATED ALWAYS AS ((raw ->> 'video_id')::uuid) STORED REFERENCES "public"."video_meta"("id") ON DELETE CASCADE,
  "frame_idx" int4 NOT NULL GENERATED ALWAYS AS ((raw ->> 'frame_idx')::int4) STORED,
  "bounding_box" jsonb NOT NULL GENERATED ALWAYS AS (raw -> 'bounding_box') STORED,
  "confidence" numeric(5,4) GENERATED ALWAYS AS ((raw ->> 'confidence')::numeric(5,4)) STORED,
  "face_embedding" vector(512) GENERATED ALWAYS AS ((raw ->> 'face_embedding')::vector(512)) STORED,
  "person_id" uuid GENERATED ALWAYS AS ((raw ->> 'person_id')::uuid) STORED,
  "person_name" varchar(100) GENERATED ALWAYS AS (raw ->> 'person_name') STORED,
  "create_time_at" timestamptz(6) NOT NULL DEFAULT now(),
  PRIMARY KEY ("id"),
  CONSTRAINT chk_face_confidence CHECK (confidence BETWEEN 0 AND 1)
);
CREATE INDEX IF NOT EXISTS idx_face_video_id ON face_detection(video_id);
CREATE INDEX IF NOT EXISTS idx_face_person_id ON face_detection(person_id);
CREATE INDEX IF NOT EXISTS idx_face_frame_idx ON face_detection(video_id, frame_idx);
CREATE INDEX IF NOT EXISTS idx_face_embedding_hnsw
ON face_detection USING hnsw (face_embedding vector_cosine_ops)
WITH (m = 32, ef_construction = 128)
WHERE face_embedding IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_face_raw_gin ON face_detection USING gin(raw);
COMMENT ON TABLE "public"."face_detection" IS '人脸检测表，支持人物识别和追踪';

-- 仅插入，不更新，无update触发器

-- =============================================
-- 6. subtitle（字幕表）
-- =============================================
CREATE TABLE IF NOT EXISTS "public"."subtitle" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "raw" jsonb NOT NULL, -- 原始完整快照
  "video_id" uuid NOT NULL GENERATED ALWAYS AS ((raw ->> 'video_id')::uuid) STORED REFERENCES "public"."video_meta"("id") ON DELETE CASCADE,
  "start_time" numeric(12,6) NOT NULL GENERATED ALWAYS AS ((raw ->> 'start_time')::numeric(12,6)) STORED,
  "end_time" numeric(12,6) NOT NULL GENERATED ALWAYS AS ((raw ->> 'end_time')::numeric(12,6)) STORED,
  "text" text NOT NULL GENERATED ALWAYS AS (raw ->> 'text') STORED,
  "language" varchar(10) GENERATED ALWAYS AS (coalesce(raw ->> 'language','eng')) STORED,
  "style" jsonb GENERATED ALWAYS AS (raw -> 'style') STORED,
  "source" varchar(20) GENERATED ALWAYS AS (raw ->> 'source') STORED,
  "create_time_at" timestamptz(6) NOT NULL DEFAULT now(),
  "update_time_at" timestamptz(6) NOT NULL DEFAULT now(),
  PRIMARY KEY ("id"),
  CONSTRAINT chk_subtitle_time CHECK (end_time >= start_time AND start_time >=0)
);
CREATE INDEX IF NOT EXISTS idx_subtitle_video_id ON subtitle(video_id);
CREATE INDEX IF NOT EXISTS idx_subtitle_time ON subtitle(video_id, start_time, end_time);
CREATE INDEX IF NOT EXISTS idx_subtitle_text_gin ON subtitle USING gin(to_tsvector('simple', text));
CREATE INDEX IF NOT EXISTS idx_subtitle_raw_gin ON subtitle USING gin(raw);
COMMENT ON TABLE "public"."subtitle" IS '字幕表，支持多语言和时间轴查询';

CREATE TRIGGER trigger_subtitle_update
BEFORE UPDATE ON subtitle
FOR EACH ROW
EXECUTE FUNCTION public.set_update_time_at();

-- =============================================
-- 表注释汇总
-- =============================================
COMMENT ON TABLE "public"."asset" IS '✅ 媒体资产表';
COMMENT ON TABLE "public"."analysis_result" IS '✅ 分析结果统一表';
COMMENT ON TABLE "public"."video_segment" IS '✅ 视频分段表';
COMMENT ON TABLE "public"."ocr_result" IS '✅ OCR 结果表';
COMMENT ON TABLE "public"."face_detection" IS '✅ 人脸检测表';
COMMENT ON TABLE "public"."subtitle" IS '✅ 字幕表';

-- =============================================
-- 验证SQL
-- =============================================
/*
-- 查看全部12张表
\dt public.*

-- 查看生成列定义
SELECT table_name, column_name, generation_expression
FROM information_schema.columns
WHERE table_schema='public' AND is_generated = 'ALWAYS';
*/
