/*
PostgreSQL Backup
Database: postgres/public
Backup Time: 2026-09-20 09:56:14
*/

DROP TABLE IF EXISTS "public"."activity_execution";
DROP TABLE IF EXISTS "public"."analysis_result";
DROP TABLE IF EXISTS "public"."asset";
DROP TABLE IF EXISTS "public"."face_detection";
DROP TABLE IF EXISTS "public"."ocr_result";
DROP TABLE IF EXISTS "public"."review_risk";
DROP TABLE IF EXISTS "public"."subtitle";
DROP TABLE IF EXISTS "public"."task_checkpoint";
DROP TABLE IF EXISTS "public"."video_frames";
DROP TABLE IF EXISTS "public"."video_meta";
DROP TABLE IF EXISTS "public"."video_process_stage";
DROP TABLE IF EXISTS "public"."video_segment";
DROP TABLE IF EXISTS "public"."video_task";
DROP FUNCTION IF EXISTS "public"."NewProc"();
DROP FUNCTION IF EXISTS "public"."_navicat_temp_stored_proc"(p_video_id uuid);
DROP FUNCTION IF EXISTS "public"."_navicat_temp_stored_proc"(v "public"."vector");
DROP FUNCTION IF EXISTS "public"."armor"(bytea, _text, _text);
DROP FUNCTION IF EXISTS "public"."armor"(bytea);
DROP FUNCTION IF EXISTS "public"."array_to_halfvec"(_float8, int4, bool);
DROP FUNCTION IF EXISTS "public"."array_to_halfvec"(_float4, int4, bool);
DROP FUNCTION IF EXISTS "public"."array_to_halfvec"(_int4, int4, bool);
DROP FUNCTION IF EXISTS "public"."array_to_halfvec"(_numeric, int4, bool);
DROP FUNCTION IF EXISTS "public"."array_to_sparsevec"(_float4, int4, bool);
DROP FUNCTION IF EXISTS "public"."array_to_sparsevec"(_int4, int4, bool);
DROP FUNCTION IF EXISTS "public"."array_to_sparsevec"(_float8, int4, bool);
DROP FUNCTION IF EXISTS "public"."array_to_sparsevec"(_numeric, int4, bool);
DROP FUNCTION IF EXISTS "public"."array_to_vector"(_float4, int4, bool);
DROP FUNCTION IF EXISTS "public"."array_to_vector"(_int4, int4, bool);
DROP FUNCTION IF EXISTS "public"."array_to_vector"(_numeric, int4, bool);
DROP FUNCTION IF EXISTS "public"."array_to_vector"(_float8, int4, bool);
DROP FUNCTION IF EXISTS "public"."binary_quantize"("public"."vector");
DROP FUNCTION IF EXISTS "public"."binary_quantize"("public"."halfvec");
DROP FUNCTION IF EXISTS "public"."bit_hamming"(a bit, b bit);
DROP FUNCTION IF EXISTS "public"."cosine_distance"("public"."halfvec", "public"."halfvec");
DROP FUNCTION IF EXISTS "public"."cosine_distance"("public"."sparsevec", "public"."sparsevec");
DROP FUNCTION IF EXISTS "public"."cosine_distance"("public"."vector", "public"."vector");
DROP FUNCTION IF EXISTS "public"."crypt"(text, text);
DROP FUNCTION IF EXISTS "public"."dearmor"(text);
DROP FUNCTION IF EXISTS "public"."decrypt"(bytea, bytea, text);
DROP FUNCTION IF EXISTS "public"."decrypt_iv"(bytea, bytea, bytea, text);
DROP FUNCTION IF EXISTS "public"."digest"(bytea, text);
DROP FUNCTION IF EXISTS "public"."digest"(text, text);
DROP FUNCTION IF EXISTS "public"."encrypt"(bytea, bytea, text);
DROP FUNCTION IF EXISTS "public"."encrypt_iv"(bytea, bytea, bytea, text);
DROP FUNCTION IF EXISTS "public"."gen_random_bytes"(int4);
DROP FUNCTION IF EXISTS "public"."gen_random_uuid"();
DROP FUNCTION IF EXISTS "public"."gen_salt"(text, int4);
DROP FUNCTION IF EXISTS "public"."gen_salt"(text);
DROP FUNCTION IF EXISTS "public"."get_video_review_images"(p_video_id uuid);
DROP FUNCTION IF EXISTS "public"."halfvec"("public"."halfvec", int4, bool);
DROP FUNCTION IF EXISTS "public"."halfvec_accum"(_float8, "public"."halfvec");
DROP FUNCTION IF EXISTS "public"."halfvec_add"("public"."halfvec", "public"."halfvec");
DROP FUNCTION IF EXISTS "public"."halfvec_avg"(_float8);
DROP FUNCTION IF EXISTS "public"."halfvec_cmp"("public"."halfvec", "public"."halfvec");
DROP FUNCTION IF EXISTS "public"."halfvec_combine"(_float8, _float8);
DROP FUNCTION IF EXISTS "public"."halfvec_concat"("public"."halfvec", "public"."halfvec");
DROP FUNCTION IF EXISTS "public"."halfvec_eq"("public"."halfvec", "public"."halfvec");
DROP FUNCTION IF EXISTS "public"."halfvec_ge"("public"."halfvec", "public"."halfvec");
DROP FUNCTION IF EXISTS "public"."halfvec_gt"("public"."halfvec", "public"."halfvec");
DROP FUNCTION IF EXISTS "public"."halfvec_in"(cstring, oid, int4);
DROP FUNCTION IF EXISTS "public"."halfvec_l2_squared_distance"("public"."halfvec", "public"."halfvec");
DROP FUNCTION IF EXISTS "public"."halfvec_le"("public"."halfvec", "public"."halfvec");
DROP FUNCTION IF EXISTS "public"."halfvec_lt"("public"."halfvec", "public"."halfvec");
DROP FUNCTION IF EXISTS "public"."halfvec_mul"("public"."halfvec", "public"."halfvec");
DROP FUNCTION IF EXISTS "public"."halfvec_ne"("public"."halfvec", "public"."halfvec");
DROP FUNCTION IF EXISTS "public"."halfvec_negative_inner_product"("public"."halfvec", "public"."halfvec");
DROP FUNCTION IF EXISTS "public"."halfvec_out"("public"."halfvec");
DROP FUNCTION IF EXISTS "public"."halfvec_recv"(internal, oid, int4);
DROP FUNCTION IF EXISTS "public"."halfvec_send"("public"."halfvec");
DROP FUNCTION IF EXISTS "public"."halfvec_spherical_distance"("public"."halfvec", "public"."halfvec");
DROP FUNCTION IF EXISTS "public"."halfvec_sub"("public"."halfvec", "public"."halfvec");
DROP FUNCTION IF EXISTS "public"."halfvec_to_float4"("public"."halfvec", int4, bool);
DROP FUNCTION IF EXISTS "public"."halfvec_to_sparsevec"("public"."halfvec", int4, bool);
DROP FUNCTION IF EXISTS "public"."halfvec_to_vector"("public"."halfvec", int4, bool);
DROP FUNCTION IF EXISTS "public"."halfvec_typmod_in"(_cstring);
DROP FUNCTION IF EXISTS "public"."hamming_distance"(bit, bit);
DROP FUNCTION IF EXISTS "public"."hmac"(bytea, bytea, text);
DROP FUNCTION IF EXISTS "public"."hmac"(text, text, text);
DROP FUNCTION IF EXISTS "public"."hnsw_bit_support"(internal);
DROP FUNCTION IF EXISTS "public"."hnsw_halfvec_support"(internal);
DROP FUNCTION IF EXISTS "public"."hnsw_sparsevec_support"(internal);
DROP FUNCTION IF EXISTS "public"."hnswhandler"(internal);
DROP FUNCTION IF EXISTS "public"."inner_product"("public"."sparsevec", "public"."sparsevec");
DROP FUNCTION IF EXISTS "public"."inner_product"("public"."vector", "public"."vector");
DROP FUNCTION IF EXISTS "public"."inner_product"("public"."halfvec", "public"."halfvec");
DROP FUNCTION IF EXISTS "public"."ivfflat_bit_support"(internal);
DROP FUNCTION IF EXISTS "public"."ivfflat_halfvec_support"(internal);
DROP FUNCTION IF EXISTS "public"."ivfflathandler"(internal);
DROP FUNCTION IF EXISTS "public"."jaccard_distance"(bit, bit);
DROP FUNCTION IF EXISTS "public"."l1_distance"("public"."halfvec", "public"."halfvec");
DROP FUNCTION IF EXISTS "public"."l1_distance"("public"."sparsevec", "public"."sparsevec");
DROP FUNCTION IF EXISTS "public"."l1_distance"("public"."vector", "public"."vector");
DROP FUNCTION IF EXISTS "public"."l2_distance"("public"."sparsevec", "public"."sparsevec");
DROP FUNCTION IF EXISTS "public"."l2_distance"("public"."halfvec", "public"."halfvec");
DROP FUNCTION IF EXISTS "public"."l2_distance"("public"."vector", "public"."vector");
DROP FUNCTION IF EXISTS "public"."l2_norm"("public"."halfvec");
DROP FUNCTION IF EXISTS "public"."l2_norm"("public"."sparsevec");
DROP FUNCTION IF EXISTS "public"."l2_normalize"("public"."sparsevec");
DROP FUNCTION IF EXISTS "public"."l2_normalize"("public"."vector");
DROP FUNCTION IF EXISTS "public"."l2_normalize"("public"."halfvec");
DROP FUNCTION IF EXISTS "public"."pgp_armor_headers"(text, OUT key text, OUT value text);
DROP FUNCTION IF EXISTS "public"."pgp_key_id"(bytea);
DROP FUNCTION IF EXISTS "public"."pgp_pub_decrypt"(bytea, bytea, text);
DROP FUNCTION IF EXISTS "public"."pgp_pub_decrypt"(bytea, bytea);
DROP FUNCTION IF EXISTS "public"."pgp_pub_decrypt"(bytea, bytea, text, text);
DROP FUNCTION IF EXISTS "public"."pgp_pub_decrypt_bytea"(bytea, bytea, text);
DROP FUNCTION IF EXISTS "public"."pgp_pub_decrypt_bytea"(bytea, bytea);
DROP FUNCTION IF EXISTS "public"."pgp_pub_decrypt_bytea"(bytea, bytea, text, text);
DROP FUNCTION IF EXISTS "public"."pgp_pub_encrypt"(text, bytea);
DROP FUNCTION IF EXISTS "public"."pgp_pub_encrypt"(text, bytea, text);
DROP FUNCTION IF EXISTS "public"."pgp_pub_encrypt_bytea"(bytea, bytea, text);
DROP FUNCTION IF EXISTS "public"."pgp_pub_encrypt_bytea"(bytea, bytea);
DROP FUNCTION IF EXISTS "public"."pgp_sym_decrypt"(bytea, text);
DROP FUNCTION IF EXISTS "public"."pgp_sym_decrypt"(bytea, text, text);
DROP FUNCTION IF EXISTS "public"."pgp_sym_decrypt_bytea"(bytea, text);
DROP FUNCTION IF EXISTS "public"."pgp_sym_decrypt_bytea"(bytea, text, text);
DROP FUNCTION IF EXISTS "public"."pgp_sym_encrypt"(text, text, text);
DROP FUNCTION IF EXISTS "public"."pgp_sym_encrypt"(text, text);
DROP FUNCTION IF EXISTS "public"."pgp_sym_encrypt_bytea"(bytea, text, text);
DROP FUNCTION IF EXISTS "public"."pgp_sym_encrypt_bytea"(bytea, text);
DROP FUNCTION IF EXISTS "public"."phash_distance"(hash1 text, hash2 text);
DROP FUNCTION IF EXISTS "public"."phash_hex_to_bit64"(hex text);
DROP FUNCTION IF EXISTS "public"."phash_hex_to_vector64"(hex_str text);
DROP FUNCTION IF EXISTS "public"."phash_vector64_to_hex"(v "public"."vector");
DROP FUNCTION IF EXISTS "public"."process_video_review"(in_video_id uuid);
DROP FUNCTION IF EXISTS "public"."set_update_time_at"();
DROP FUNCTION IF EXISTS "public"."set_update_time_at_frames"();
DROP FUNCTION IF EXISTS "public"."set_update_time_at_meta"();
DROP FUNCTION IF EXISTS "public"."sparsevec"("public"."sparsevec", int4, bool);
DROP FUNCTION IF EXISTS "public"."sparsevec_cmp"("public"."sparsevec", "public"."sparsevec");
DROP FUNCTION IF EXISTS "public"."sparsevec_eq"("public"."sparsevec", "public"."sparsevec");
DROP FUNCTION IF EXISTS "public"."sparsevec_ge"("public"."sparsevec", "public"."sparsevec");
DROP FUNCTION IF EXISTS "public"."sparsevec_gt"("public"."sparsevec", "public"."sparsevec");
DROP FUNCTION IF EXISTS "public"."sparsevec_in"(cstring, oid, int4);
DROP FUNCTION IF EXISTS "public"."sparsevec_l2_squared_distance"("public"."sparsevec", "public"."sparsevec");
DROP FUNCTION IF EXISTS "public"."sparsevec_le"("public"."sparsevec", "public"."sparsevec");
DROP FUNCTION IF EXISTS "public"."sparsevec_lt"("public"."sparsevec", "public"."sparsevec");
DROP FUNCTION IF EXISTS "public"."sparsevec_ne"("public"."sparsevec", "public"."sparsevec");
DROP FUNCTION IF EXISTS "public"."sparsevec_negative_inner_product"("public"."sparsevec", "public"."sparsevec");
DROP FUNCTION IF EXISTS "public"."sparsevec_out"("public"."sparsevec");
DROP FUNCTION IF EXISTS "public"."sparsevec_recv"(internal, oid, int4);
DROP FUNCTION IF EXISTS "public"."sparsevec_send"("public"."sparsevec");
DROP FUNCTION IF EXISTS "public"."sparsevec_to_halfvec"("public"."sparsevec", int4, bool);
DROP FUNCTION IF EXISTS "public"."sparsevec_to_vector"("public"."sparsevec", int4, bool);
DROP FUNCTION IF EXISTS "public"."sparsevec_typmod_in"(_cstring);
DROP FUNCTION IF EXISTS "public"."subvector"("public"."vector", int4, int4);
DROP FUNCTION IF EXISTS "public"."subvector"("public"."halfvec", int4, int4);
DROP FUNCTION IF EXISTS "public"."toTimestamptz"(value text);
DROP FUNCTION IF EXISTS "public"."to_bigint"(input_str text);
DROP FUNCTION IF EXISTS "public"."to_int"(input_str text);
DROP FUNCTION IF EXISTS "public"."to_numeric"(input_str text);
DROP FUNCTION IF EXISTS "public"."to_timestamptz"(input_str text);
DROP FUNCTION IF EXISTS "public"."to_uuid"(input_str text);
DROP FUNCTION IF EXISTS "public"."uuid_generate_v1"();
DROP FUNCTION IF EXISTS "public"."uuid_generate_v1mc"();
DROP FUNCTION IF EXISTS "public"."uuid_generate_v3"(namespace uuid, name text);
DROP FUNCTION IF EXISTS "public"."uuid_generate_v4"();
DROP FUNCTION IF EXISTS "public"."uuid_generate_v5"(namespace uuid, name text);
DROP FUNCTION IF EXISTS "public"."uuid_nil"();
DROP FUNCTION IF EXISTS "public"."uuid_ns_dns"();
DROP FUNCTION IF EXISTS "public"."uuid_ns_oid"();
DROP FUNCTION IF EXISTS "public"."uuid_ns_url"();
DROP FUNCTION IF EXISTS "public"."uuid_ns_x500"();
DROP FUNCTION IF EXISTS "public"."vector"("public"."vector", int4, bool);
DROP FUNCTION IF EXISTS "public"."vector_accum"(_float8, "public"."vector");
DROP FUNCTION IF EXISTS "public"."vector_add"("public"."vector", "public"."vector");
DROP FUNCTION IF EXISTS "public"."vector_avg"(_float8);
DROP FUNCTION IF EXISTS "public"."vector_cmp"("public"."vector", "public"."vector");
DROP FUNCTION IF EXISTS "public"."vector_combine"(_float8, _float8);
DROP FUNCTION IF EXISTS "public"."vector_concat"("public"."vector", "public"."vector");
DROP FUNCTION IF EXISTS "public"."vector_dims"("public"."vector");
DROP FUNCTION IF EXISTS "public"."vector_dims"("public"."halfvec");
DROP FUNCTION IF EXISTS "public"."vector_eq"("public"."vector", "public"."vector");
DROP FUNCTION IF EXISTS "public"."vector_ge"("public"."vector", "public"."vector");
DROP FUNCTION IF EXISTS "public"."vector_gt"("public"."vector", "public"."vector");
DROP FUNCTION IF EXISTS "public"."vector_in"(cstring, oid, int4);
DROP FUNCTION IF EXISTS "public"."vector_l2_squared_distance"("public"."vector", "public"."vector");
DROP FUNCTION IF EXISTS "public"."vector_le"("public"."vector", "public"."vector");
DROP FUNCTION IF EXISTS "public"."vector_lt"("public"."vector", "public"."vector");
DROP FUNCTION IF EXISTS "public"."vector_mul"("public"."vector", "public"."vector");
DROP FUNCTION IF EXISTS "public"."vector_ne"("public"."vector", "public"."vector");
DROP FUNCTION IF EXISTS "public"."vector_negative_inner_product"("public"."vector", "public"."vector");
DROP FUNCTION IF EXISTS "public"."vector_norm"("public"."vector");
DROP FUNCTION IF EXISTS "public"."vector_out"("public"."vector");
DROP FUNCTION IF EXISTS "public"."vector_recv"(internal, oid, int4);
DROP FUNCTION IF EXISTS "public"."vector_send"("public"."vector");
DROP FUNCTION IF EXISTS "public"."vector_spherical_distance"("public"."vector", "public"."vector");
DROP FUNCTION IF EXISTS "public"."vector_sub"("public"."vector", "public"."vector");
DROP FUNCTION IF EXISTS "public"."vector_to_float4"("public"."vector", int4, bool);
DROP FUNCTION IF EXISTS "public"."vector_to_halfvec"("public"."vector", int4, bool);
DROP FUNCTION IF EXISTS "public"."vector_to_sparsevec"("public"."vector", int4, bool);
DROP FUNCTION IF EXISTS "public"."vector_typmod_in"(_cstring);
DROP TYPE IF EXISTS "public"."halfvec";
DROP TYPE IF EXISTS "public"."sparsevec";
DROP TYPE IF EXISTS "public"."vector";
CREATE TYPE "halfvec" (
  INPUT = "public"."halfvec_in",
  OUTPUT = "public"."halfvec_out",
  RECEIVE = "public"."halfvec_recv",
  SEND = "public"."halfvec_send",
  TYPMOD_IN = "public"."halfvec_typmod_in",
  INTERNALLENGTH = VARIABLE,
  STORAGE = external,
  CATEGORY = U,
  DELIMITER = ','
);
ALTER TYPE "halfvec" OWNER TO "postgres";
CREATE TYPE "sparsevec" (
  INPUT = "public"."sparsevec_in",
  OUTPUT = "public"."sparsevec_out",
  RECEIVE = "public"."sparsevec_recv",
  SEND = "public"."sparsevec_send",
  TYPMOD_IN = "public"."sparsevec_typmod_in",
  INTERNALLENGTH = VARIABLE,
  STORAGE = external,
  CATEGORY = U,
  DELIMITER = ','
);
ALTER TYPE "sparsevec" OWNER TO "postgres";
CREATE TYPE "vector" (
  INPUT = "public"."vector_in",
  OUTPUT = "public"."vector_out",
  RECEIVE = "public"."vector_recv",
  SEND = "public"."vector_send",
  TYPMOD_IN = "public"."vector_typmod_in",
  INTERNALLENGTH = VARIABLE,
  STORAGE = external,
  CATEGORY = U,
  DELIMITER = ','
);
ALTER TYPE "vector" OWNER TO "postgres";
CREATE TABLE "activity_execution" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "activity_name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "idempotency_key" text COLLATE "pg_catalog"."default" NOT NULL,
  "status" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "result" jsonb,
  "raw_request" jsonb NOT NULL,
  "error_message" text COLLATE "pg_catalog"."default",
  "create_time_at" timestamptz(6) NOT NULL DEFAULT now(),
  "completed_at" timestamptz(6)
)
;
ALTER TABLE "activity_execution" OWNER TO "postgres";
CREATE TABLE "analysis_result" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "raw" jsonb NOT NULL,
  "asset_id" uuid NOT NULL GENERATED ALWAYS AS (
((raw ->> 'asset_id'::text))::uuid
) STORED,
  "frame_idx" int4 GENERATED ALWAYS AS (
((raw ->> 'frame_idx'::text))::integer
) STORED,
  "analysis_type" varchar(50) COLLATE "pg_catalog"."default" NOT NULL GENERATED ALWAYS AS (
(raw ->> 'analysis_type'::text)
) STORED,
  "result" jsonb NOT NULL GENERATED ALWAYS AS (
(raw -> 'result'::text)
) STORED,
  "model_name" varchar(100) COLLATE "pg_catalog"."default" GENERATED ALWAYS AS (
(raw ->> 'model_name'::text)
) STORED,
  "model_version" varchar(20) COLLATE "pg_catalog"."default" GENERATED ALWAYS AS (
(raw ->> 'model_version'::text)
) STORED,
  "confidence" numeric(5,4) GENERATED ALWAYS AS (
((raw ->> 'confidence'::text))::numeric(5,4)
) STORED,
  "create_time_at" timestamptz(6) NOT NULL DEFAULT now()
)
;
ALTER TABLE "analysis_result" OWNER TO "postgres";
COMMENT ON TABLE "analysis_result" IS '✅ 分析结果统一表';
CREATE TABLE "asset" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "raw" jsonb NOT NULL,
  "type" varchar(20) COLLATE "pg_catalog"."default" NOT NULL GENERATED ALWAYS AS (
(raw ->> 'type'::text)
) STORED,
  "storage_key" text COLLATE "pg_catalog"."default" NOT NULL GENERATED ALWAYS AS (
(raw ->> 'storage_key'::text)
) STORED,
  "file_hash" varchar(64) COLLATE "pg_catalog"."default" GENERATED ALWAYS AS (
(raw ->> 'file_hash'::text)
) STORED,
  "metadata" jsonb GENERATED ALWAYS AS (
(raw -> 'metadata'::text)
) STORED,
  "create_time_at" timestamptz(6) NOT NULL DEFAULT now(),
  "update_time_at" timestamptz(6) NOT NULL DEFAULT now()
)
;
ALTER TABLE "asset" OWNER TO "postgres";
COMMENT ON TABLE "asset" IS '✅ 媒体资产表';
CREATE TABLE "face_detection" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "raw" jsonb NOT NULL,
  "video_id" uuid NOT NULL GENERATED ALWAYS AS (
((raw ->> 'video_id'::text))::uuid
) STORED,
  "frame_idx" int4 NOT NULL GENERATED ALWAYS AS (
((raw ->> 'frame_idx'::text))::integer
) STORED,
  "bounding_box" jsonb NOT NULL GENERATED ALWAYS AS (
(raw -> 'bounding_box'::text)
) STORED,
  "confidence" numeric(5,4) GENERATED ALWAYS AS (
((raw ->> 'confidence'::text))::numeric(5,4)
) STORED,
  "face_embedding" vector(512) GENERATED ALWAYS AS (
((raw ->> 'face_embedding'::text))::vector(512)
) STORED,
  "person_id" uuid GENERATED ALWAYS AS (
((raw ->> 'person_id'::text))::uuid
) STORED,
  "person_name" varchar(100) COLLATE "pg_catalog"."default" GENERATED ALWAYS AS (
(raw ->> 'person_name'::text)
) STORED,
  "create_time_at" timestamptz(6) NOT NULL DEFAULT now()
)
;
ALTER TABLE "face_detection" OWNER TO "postgres";
COMMENT ON TABLE "face_detection" IS '✅ 人脸检测表';
CREATE TABLE "ocr_result" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "raw" jsonb NOT NULL,
  "video_id" uuid NOT NULL GENERATED ALWAYS AS (
((raw ->> 'video_id'::text))::uuid
) STORED,
  "frame_idx" int4 NOT NULL GENERATED ALWAYS AS (
((raw ->> 'frame_idx'::text))::integer
) STORED,
  "region_hash" varchar(8) COLLATE "pg_catalog"."default" GENERATED ALWAYS AS (
(raw ->> 'region_hash'::text)
) STORED,
  "text" text COLLATE "pg_catalog"."default" NOT NULL GENERATED ALWAYS AS (
(raw ->> 'text'::text)
) STORED,
  "confidence" numeric(5,4) GENERATED ALWAYS AS (
((raw ->> 'confidence'::text))::numeric(5,4)
) STORED,
  "bounding_box" jsonb GENERATED ALWAYS AS (
(raw -> 'bounding_box'::text)
) STORED,
  "language" varchar(10) COLLATE "pg_catalog"."default" GENERATED ALWAYS AS (
COALESCE((raw ->> 'language'::text), 'eng'::text)
) STORED,
  "create_time_at" timestamptz(6) NOT NULL DEFAULT now()
)
;
ALTER TABLE "ocr_result" OWNER TO "postgres";
COMMENT ON TABLE "ocr_result" IS '✅ OCR 结果表';
CREATE TABLE "review_risk" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "risk_code" text COLLATE "pg_catalog"."default" NOT NULL,
  "risk_name" text COLLATE "pg_catalog"."default" NOT NULL,
  "risk_level" int4 NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "is_active" bool NOT NULL DEFAULT true,
  "create_at" timestamptz(6) NOT NULL DEFAULT now()
)
;
ALTER TABLE "review_risk" OWNER TO "postgres";
COMMENT ON COLUMN "review_risk"."risk_code" IS '????(?????????)';
COMMENT ON COLUMN "review_risk"."risk_name" IS '?????????????';
COMMENT ON COLUMN "review_risk"."risk_level" IS '???? 1=?? 2=?? 3=??';
COMMENT ON COLUMN "review_risk"."is_active" IS '????';
COMMENT ON TABLE "review_risk" IS '???????';
CREATE TABLE "subtitle" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "raw" jsonb NOT NULL,
  "video_id" uuid NOT NULL GENERATED ALWAYS AS (
((raw ->> 'video_id'::text))::uuid
) STORED,
  "start_time" numeric(12,6) NOT NULL GENERATED ALWAYS AS (
((raw ->> 'start_time'::text))::numeric(12,6)
) STORED,
  "end_time" numeric(12,6) NOT NULL GENERATED ALWAYS AS (
((raw ->> 'end_time'::text))::numeric(12,6)
) STORED,
  "text" text COLLATE "pg_catalog"."default" NOT NULL GENERATED ALWAYS AS (
(raw ->> 'text'::text)
) STORED,
  "language" varchar(10) COLLATE "pg_catalog"."default" GENERATED ALWAYS AS (
COALESCE((raw ->> 'language'::text), 'eng'::text)
) STORED,
  "style" jsonb GENERATED ALWAYS AS (
(raw -> 'style'::text)
) STORED,
  "source" varchar(20) COLLATE "pg_catalog"."default" GENERATED ALWAYS AS (
(raw ->> 'source'::text)
) STORED,
  "create_time_at" timestamptz(6) NOT NULL DEFAULT now(),
  "update_time_at" timestamptz(6) NOT NULL DEFAULT now()
)
;
ALTER TABLE "subtitle" OWNER TO "postgres";
COMMENT ON TABLE "subtitle" IS '✅ 字幕表';
CREATE TABLE "task_checkpoint" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "video_id" uuid NOT NULL,
  "stage" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "checkpoint_data" jsonb NOT NULL,
  "raw" jsonb,
  "create_time_at" timestamptz(6) NOT NULL DEFAULT now(),
  "update_time_at" timestamptz(6) NOT NULL DEFAULT now()
)
;
ALTER TABLE "task_checkpoint" OWNER TO "postgres";
CREATE TABLE "video_frames" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "video_id" uuid NOT NULL,
  "raw" jsonb NOT NULL,
  "phash_hex" text COLLATE "pg_catalog"."default" GENERATED ALWAYS AS (
(raw ->> 'phash'::text)
) STORED,
  "phash_bits" bit(64) GENERATED ALWAYS AS (
phash_hex_to_bit64((raw ->> 'phash'::text))
) STORED,
  "phash_vec" vector(64) GENERATED ALWAYS AS (
phash_hex_to_vector64((raw ->> 'phash'::text))
) STORED,
  "frame_type" text COLLATE "pg_catalog"."default" GENERATED ALWAYS AS (
(raw ->> 'frameType'::text)
) STORED,
  "workflow_id" text COLLATE "pg_catalog"."default" GENERATED ALWAYS AS (
(raw ->> 'workflowId'::text)
) STORED,
  "has_image" bool,
  "review_status" text COLLATE "pg_catalog"."default",
  "review_comment" text COLLATE "pg_catalog"."default",
  "img_url" text COLLATE "pg_catalog"."default",
  "risk_ids" uuid[],
  "pts_time" numeric(12,6) NOT NULL,
  "idx" int4 NOT NULL,
  "create_time_at" timestamptz(6) NOT NULL DEFAULT now(),
  "update_time_at" timestamptz(6) NOT NULL DEFAULT now()
)
;
ALTER TABLE "video_frames" OWNER TO "postgres";
COMMENT ON COLUMN "video_frames"."has_image" IS '????????';
COMMENT ON COLUMN "video_frames"."review_status" IS '????';
COMMENT ON COLUMN "video_frames"."review_comment" IS '????';
COMMENT ON COLUMN "video_frames"."img_url" IS '??????';
COMMENT ON COLUMN "video_frames"."risk_ids" IS '??????ID?????review_risk.id???????????null';
CREATE TABLE "video_meta" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "raw" jsonb NOT NULL,
  "file_hash" text COLLATE "pg_catalog"."default",
  "is_valid" bool NOT NULL DEFAULT true,
  "last_modified" timestamptz(6),
  "status" text COLLATE "pg_catalog"."default",
  "processed_at" timestamptz(6),
  "scene_count" int4,
  "frame_count" int4,
  "error_message" text COLLATE "pg_catalog"."default",
  "video_phash_hex" text COLLATE "pg_catalog"."default" GENERATED ALWAYS AS (
(raw ->> 'videoPhash'::text)
) STORED,
  "video_phash_vec" vector(64) GENERATED ALWAYS AS (
phash_hex_to_vector64((raw ->> 'videoPhash'::text))
) STORED,
  "create_time_at" timestamptz(6) NOT NULL DEFAULT now(),
  "update_time_at" timestamptz(6) NOT NULL DEFAULT now()
)
;
ALTER TABLE "video_meta" OWNER TO "postgres";
COMMENT ON TABLE "video_meta" IS '??????';
CREATE TABLE "video_process_stage" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "video_id" uuid NOT NULL,
  "stage" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "status" varchar(20) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'PENDING'::character varying,
  "progress" numeric(5,4) DEFAULT 0,
  "raw" jsonb,
  "started_at" timestamptz(6),
  "completed_at" timestamptz(6),
  "create_time_at" timestamptz(6) NOT NULL DEFAULT now(),
  "update_time_at" timestamptz(6) NOT NULL DEFAULT now()
)
;
ALTER TABLE "video_process_stage" OWNER TO "postgres";
CREATE TABLE "video_segment" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "raw" jsonb NOT NULL,
  "video_id" uuid NOT NULL GENERATED ALWAYS AS (
((raw ->> 'video_id'::text))::uuid
) STORED,
  "start_time" numeric(12,6) NOT NULL GENERATED ALWAYS AS (
((raw ->> 'start_time'::text))::numeric(12,6)
) STORED,
  "end_time" numeric(12,6) NOT NULL GENERATED ALWAYS AS (
((raw ->> 'end_time'::text))::numeric(12,6)
) STORED,
  "segment_type" varchar(20) COLLATE "pg_catalog"."default" NOT NULL GENERATED ALWAYS AS (
(raw ->> 'segment_type'::text)
) STORED,
  "confidence" numeric(5,4) GENERATED ALWAYS AS (
((raw ->> 'confidence'::text))::numeric(5,4)
) STORED,
  "metadata" jsonb GENERATED ALWAYS AS (
(raw -> 'metadata'::text)
) STORED,
  "create_time_at" timestamptz(6) NOT NULL DEFAULT now(),
  "update_time_at" timestamptz(6) NOT NULL DEFAULT now()
)
;
ALTER TABLE "video_segment" OWNER TO "postgres";
COMMENT ON TABLE "video_segment" IS '✅ 视频分段表';
CREATE TABLE "video_task" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "video_id" uuid NOT NULL,
  "status" varchar(20) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'PENDING'::character varying,
  "current_stage" varchar(50) COLLATE "pg_catalog"."default",
  "progress" numeric(5,4) DEFAULT 0,
  "progress_message" text COLLATE "pg_catalog"."default",
  "workflow_id" varchar(100) COLLATE "pg_catalog"."default",
  "workflow_run_id" varchar(100) COLLATE "pg_catalog"."default",
  "raw" jsonb,
  "create_time_at" timestamptz(6) NOT NULL DEFAULT now(),
  "update_time_at" timestamptz(6) NOT NULL DEFAULT now(),
  "completed_at" timestamptz(6),
  "error_code" varchar(50) COLLATE "pg_catalog"."default",
  "error_message" text COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "video_task" OWNER TO "postgres";
CREATE FUNCTION "NewProc"()
  RETURNS "pg_catalog"."void" AS $BODY$BEGIN
  -- Routine body goes here...

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "NewProc"() OWNER TO "postgres";
CREATE FUNCTION "_navicat_temp_stored_proc"("p_video_id" uuid)
  RETURNS TABLE("row_no" int8, "video_id" uuid, "group_id" int8, "start_idx" int4, "end_idx" int4, "start_pts" numeric, "end_pts" numeric, "duration" numeric, "min_hamming" int4, "max_match_count" int8, "review_idx" int4, "img_path" text, "risk_level" text) AS $BODY$
BEGIN
RETURN QUERY
WITH candidates AS (
    SELECT
        a.video_id,
        a.id,
        a.idx,
        a.pts_time,
        a.phash_hex,
        MIN(bit_count(a.phash_bits # b.phash_bits)) AS min_hamming,
        COUNT(*) AS match_count
    FROM video_frames a
    JOIN video_frames b
        ON b.video_id = a.video_id
       AND b.idx BETWEEN a.idx + 2 AND a.idx + 10
    WHERE a.video_id = p_video_id
      AND bit_count(a.phash_bits # b.phash_bits) <= 12
    GROUP BY
        a.video_id,
        a.id,
        a.idx,
        a.pts_time,
        a.phash_hex
),
marked AS (
    SELECT
        *,
        CASE
            WHEN LAG(idx) OVER (ORDER BY idx) IS NULL
              OR idx - LAG(idx) OVER (ORDER BY idx) > 10
            THEN 1
            ELSE 0
        END AS new_group
    FROM candidates
),
grouped AS (
    SELECT
        *,
        SUM(new_group) OVER (ORDER BY idx) AS group_id
    FROM marked
),
segments AS (
    SELECT
        video_id,
        group_id,
        MIN(idx) AS start_idx,
        MAX(idx) AS end_idx,
        MIN(pts_time) AS start_pts,
        MAX(pts_time) AS end_pts,
        MIN(min_hamming) AS min_hamming,
        MAX(match_count) AS max_match_count,
        MIN(idx) + ((MAX(idx) - MIN(idx)) / 2) AS review_idx
    FROM grouped
    GROUP BY video_id, group_id
)
SELECT
    ROW_NUMBER() OVER (ORDER BY start_idx) AS row_no,
    video_id,
    group_id,
    start_idx,
    end_idx,
    start_pts,
    end_pts,
    end_pts - start_pts AS duration,
    min_hamming,
    max_match_count,
    review_idx,
    '/frame_snap/frame_' || review_idx || '.jpg' AS img_path,
    CASE WHEN min_hamming <=5 THEN '高风险：静态画面，重点审核' ELSE '中风险：画面变化小，建议审核' END AS risk_level
FROM segments
ORDER BY start_idx;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION "_navicat_temp_stored_proc"("p_video_id" uuid) OWNER TO "postgres";
CREATE FUNCTION "_navicat_temp_stored_proc"("v" "public"."vector")
  RETURNS "pg_catalog"."text" AS $BODY$
DECLARE
    hex_str text := '';
    byte_val int;
    i int;
    j int;
BEGIN

    FOR i IN 0..15 LOOP

        byte_val := 0;

        FOR j IN 0..3 LOOP

            byte_val :=
                byte_val * 16 +
                (
                  (v[i*4+j+1])::int * 8 +
                  (v[i*4+j+2])::int * 4 +
                  (v[i*4+j+3])::int * 2 +
                  (v[i*4+j+4])::int
                );

        END LOOP;

        hex_str := hex_str || to_hex(byte_val);

    END LOOP;

    RETURN lower(hex_str);

END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE STRICT
  COST 100;
ALTER FUNCTION "_navicat_temp_stored_proc"("v" "public"."vector") OWNER TO "postgres";
CREATE FUNCTION "armor"(bytea, _text, _text)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pg_armor'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "armor"(bytea, _text, _text) OWNER TO "postgres";
CREATE FUNCTION "armor"(bytea)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pg_armor'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "armor"(bytea) OWNER TO "postgres";
CREATE FUNCTION "array_to_halfvec"(_float8, int4, bool)
  RETURNS "public"."halfvec" AS '$libdir/vector', 'array_to_halfvec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "array_to_halfvec"(_float8, int4, bool) OWNER TO "postgres";
CREATE FUNCTION "array_to_halfvec"(_float4, int4, bool)
  RETURNS "public"."halfvec" AS '$libdir/vector', 'array_to_halfvec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "array_to_halfvec"(_float4, int4, bool) OWNER TO "postgres";
CREATE FUNCTION "array_to_halfvec"(_int4, int4, bool)
  RETURNS "public"."halfvec" AS '$libdir/vector', 'array_to_halfvec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "array_to_halfvec"(_int4, int4, bool) OWNER TO "postgres";
CREATE FUNCTION "array_to_halfvec"(_numeric, int4, bool)
  RETURNS "public"."halfvec" AS '$libdir/vector', 'array_to_halfvec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "array_to_halfvec"(_numeric, int4, bool) OWNER TO "postgres";
CREATE FUNCTION "array_to_sparsevec"(_float4, int4, bool)
  RETURNS "public"."sparsevec" AS '$libdir/vector', 'array_to_sparsevec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "array_to_sparsevec"(_float4, int4, bool) OWNER TO "postgres";
CREATE FUNCTION "array_to_sparsevec"(_int4, int4, bool)
  RETURNS "public"."sparsevec" AS '$libdir/vector', 'array_to_sparsevec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "array_to_sparsevec"(_int4, int4, bool) OWNER TO "postgres";
CREATE FUNCTION "array_to_sparsevec"(_float8, int4, bool)
  RETURNS "public"."sparsevec" AS '$libdir/vector', 'array_to_sparsevec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "array_to_sparsevec"(_float8, int4, bool) OWNER TO "postgres";
CREATE FUNCTION "array_to_sparsevec"(_numeric, int4, bool)
  RETURNS "public"."sparsevec" AS '$libdir/vector', 'array_to_sparsevec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "array_to_sparsevec"(_numeric, int4, bool) OWNER TO "postgres";
CREATE FUNCTION "array_to_vector"(_float4, int4, bool)
  RETURNS "public"."vector" AS '$libdir/vector', 'array_to_vector'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "array_to_vector"(_float4, int4, bool) OWNER TO "postgres";
CREATE FUNCTION "array_to_vector"(_int4, int4, bool)
  RETURNS "public"."vector" AS '$libdir/vector', 'array_to_vector'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "array_to_vector"(_int4, int4, bool) OWNER TO "postgres";
CREATE FUNCTION "array_to_vector"(_numeric, int4, bool)
  RETURNS "public"."vector" AS '$libdir/vector', 'array_to_vector'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "array_to_vector"(_numeric, int4, bool) OWNER TO "postgres";
CREATE FUNCTION "array_to_vector"(_float8, int4, bool)
  RETURNS "public"."vector" AS '$libdir/vector', 'array_to_vector'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "array_to_vector"(_float8, int4, bool) OWNER TO "postgres";
CREATE FUNCTION "binary_quantize"("public"."vector")
  RETURNS "pg_catalog"."bit" AS '$libdir/vector', 'binary_quantize'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "binary_quantize"("public"."vector") OWNER TO "postgres";
CREATE FUNCTION "binary_quantize"("public"."halfvec")
  RETURNS "pg_catalog"."bit" AS '$libdir/vector', 'halfvec_binary_quantize'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "binary_quantize"("public"."halfvec") OWNER TO "postgres";
CREATE FUNCTION "bit_hamming"("a" bit, "b" bit)
  RETURNS "pg_catalog"."int4" AS $BODY$
SELECT bit_count(a # b);
$BODY$
  LANGUAGE sql IMMUTABLE STRICT
  COST 100;
ALTER FUNCTION "bit_hamming"("a" bit, "b" bit) OWNER TO "postgres";
CREATE FUNCTION "cosine_distance"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'halfvec_cosine_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "cosine_distance"("public"."halfvec", "public"."halfvec") OWNER TO "postgres";
CREATE FUNCTION "cosine_distance"("public"."sparsevec", "public"."sparsevec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'sparsevec_cosine_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "cosine_distance"("public"."sparsevec", "public"."sparsevec") OWNER TO "postgres";
CREATE FUNCTION "cosine_distance"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'cosine_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "cosine_distance"("public"."vector", "public"."vector") OWNER TO "postgres";
CREATE FUNCTION "crypt"(text, text)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pg_crypt'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "crypt"(text, text) OWNER TO "postgres";
CREATE FUNCTION "dearmor"(text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_dearmor'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "dearmor"(text) OWNER TO "postgres";
CREATE FUNCTION "decrypt"(bytea, bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_decrypt'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "decrypt"(bytea, bytea, text) OWNER TO "postgres";
CREATE FUNCTION "decrypt_iv"(bytea, bytea, bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_decrypt_iv'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "decrypt_iv"(bytea, bytea, bytea, text) OWNER TO "postgres";
CREATE FUNCTION "digest"(bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_digest'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "digest"(bytea, text) OWNER TO "postgres";
CREATE FUNCTION "digest"(text, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_digest'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "digest"(text, text) OWNER TO "postgres";
CREATE FUNCTION "encrypt"(bytea, bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_encrypt'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "encrypt"(bytea, bytea, text) OWNER TO "postgres";
CREATE FUNCTION "encrypt_iv"(bytea, bytea, bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_encrypt_iv'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "encrypt_iv"(bytea, bytea, bytea, text) OWNER TO "postgres";
CREATE FUNCTION "gen_random_bytes"(int4)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_random_bytes'
  LANGUAGE c VOLATILE STRICT
  COST 1;
ALTER FUNCTION "gen_random_bytes"(int4) OWNER TO "postgres";
CREATE FUNCTION "gen_random_uuid"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/pgcrypto', 'pg_random_uuid'
  LANGUAGE c VOLATILE
  COST 1;
ALTER FUNCTION "gen_random_uuid"() OWNER TO "postgres";
CREATE FUNCTION "gen_salt"(text, int4)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pg_gen_salt_rounds'
  LANGUAGE c VOLATILE STRICT
  COST 1;
ALTER FUNCTION "gen_salt"(text, int4) OWNER TO "postgres";
CREATE FUNCTION "gen_salt"(text)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pg_gen_salt'
  LANGUAGE c VOLATILE STRICT
  COST 1;
ALTER FUNCTION "gen_salt"(text) OWNER TO "postgres";
CREATE FUNCTION "get_video_review_images"("p_video_id" uuid)
  RETURNS TABLE("row_no" int8, "video_id" uuid, "review_idx" int4, "pts_time" float8, "min_hamming" int4, "match_count" int8, "img_path" text) AS $BODY$
    WITH candidates AS (
        SELECT
            a.video_id,
            a.idx,
            a.pts_time,

            MIN(
                bit_count(a.phash_bits # b.phash_bits)
            ) AS min_hamming,

            COUNT(*) AS match_count

        FROM video_frames a

        JOIN video_frames b
          ON b.video_id = a.video_id
         AND b.idx BETWEEN a.idx + 2 AND a.idx + 10

        WHERE a.video_id = p_video_id
          AND bit_count(a.phash_bits # b.phash_bits) < 12

        GROUP BY
            a.video_id,
            a.id,
            a.idx,
            a.pts_time
    ),

    marked AS (
        SELECT
            *,
            CASE
                WHEN LAG(idx) OVER (ORDER BY idx) IS NULL
                  OR idx - LAG(idx) OVER (ORDER BY idx) > 10
                THEN 1
                ELSE 0
            END AS new_group
        FROM candidates
    ),

    grouped AS (
        SELECT
            *,
            SUM(new_group) OVER (ORDER BY idx) AS group_id
        FROM marked
    ),

    segments AS (
        SELECT
            video_id,
            group_id,
            MIN(idx) AS start_idx,
            MAX(idx) AS end_idx,
            MIN(pts_time) AS start_pts,
            MAX(pts_time) AS end_pts,
            MIN(min_hamming) AS min_hamming,
            MAX(match_count) AS match_count
        FROM grouped
        GROUP BY
            video_id,
            group_id
    ),

    review_frames AS (
        SELECT
            *,
            start_idx + ((end_idx - start_idx) / 2) AS review_idx
        FROM segments
    )

    SELECT
        ROW_NUMBER() OVER (ORDER BY start_idx) AS row_no,
        video_id,
        review_idx,
        start_pts + ((end_pts - start_pts) / 2) AS pts_time,
        min_hamming,
        match_count,
        '/frame_snap/frame_' || review_idx || '.jpg' AS img_path

    FROM review_frames

    ORDER BY start_idx;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION "get_video_review_images"("p_video_id" uuid) OWNER TO "postgres";
CREATE FUNCTION "halfvec"("public"."halfvec", int4, bool)
  RETURNS "public"."halfvec" AS '$libdir/vector', 'halfvec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "halfvec"("public"."halfvec", int4, bool) OWNER TO "postgres";
CREATE FUNCTION "halfvec_accum"(_float8, "public"."halfvec")
  RETURNS "pg_catalog"."_float8" AS '$libdir/vector', 'halfvec_accum'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "halfvec_accum"(_float8, "public"."halfvec") OWNER TO "postgres";
CREATE FUNCTION "halfvec_add"("public"."halfvec", "public"."halfvec")
  RETURNS "public"."halfvec" AS '$libdir/vector', 'halfvec_add'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "halfvec_add"("public"."halfvec", "public"."halfvec") OWNER TO "postgres";
CREATE FUNCTION "halfvec_avg"(_float8)
  RETURNS "public"."halfvec" AS '$libdir/vector', 'halfvec_avg'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "halfvec_avg"(_float8) OWNER TO "postgres";
CREATE FUNCTION "halfvec_cmp"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."int4" AS '$libdir/vector', 'halfvec_cmp'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "halfvec_cmp"("public"."halfvec", "public"."halfvec") OWNER TO "postgres";
CREATE FUNCTION "halfvec_combine"(_float8, _float8)
  RETURNS "pg_catalog"."_float8" AS '$libdir/vector', 'vector_combine'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "halfvec_combine"(_float8, _float8) OWNER TO "postgres";
CREATE FUNCTION "halfvec_concat"("public"."halfvec", "public"."halfvec")
  RETURNS "public"."halfvec" AS '$libdir/vector', 'halfvec_concat'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "halfvec_concat"("public"."halfvec", "public"."halfvec") OWNER TO "postgres";
CREATE FUNCTION "halfvec_eq"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'halfvec_eq'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "halfvec_eq"("public"."halfvec", "public"."halfvec") OWNER TO "postgres";
CREATE FUNCTION "halfvec_ge"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'halfvec_ge'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "halfvec_ge"("public"."halfvec", "public"."halfvec") OWNER TO "postgres";
CREATE FUNCTION "halfvec_gt"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'halfvec_gt'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "halfvec_gt"("public"."halfvec", "public"."halfvec") OWNER TO "postgres";
CREATE FUNCTION "halfvec_in"(cstring, oid, int4)
  RETURNS "public"."halfvec" AS '$libdir/vector', 'halfvec_in'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "halfvec_in"(cstring, oid, int4) OWNER TO "postgres";
CREATE FUNCTION "halfvec_l2_squared_distance"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'halfvec_l2_squared_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "halfvec_l2_squared_distance"("public"."halfvec", "public"."halfvec") OWNER TO "postgres";
CREATE FUNCTION "halfvec_le"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'halfvec_le'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "halfvec_le"("public"."halfvec", "public"."halfvec") OWNER TO "postgres";
CREATE FUNCTION "halfvec_lt"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'halfvec_lt'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "halfvec_lt"("public"."halfvec", "public"."halfvec") OWNER TO "postgres";
CREATE FUNCTION "halfvec_mul"("public"."halfvec", "public"."halfvec")
  RETURNS "public"."halfvec" AS '$libdir/vector', 'halfvec_mul'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "halfvec_mul"("public"."halfvec", "public"."halfvec") OWNER TO "postgres";
CREATE FUNCTION "halfvec_ne"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'halfvec_ne'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "halfvec_ne"("public"."halfvec", "public"."halfvec") OWNER TO "postgres";
CREATE FUNCTION "halfvec_negative_inner_product"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'halfvec_negative_inner_product'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "halfvec_negative_inner_product"("public"."halfvec", "public"."halfvec") OWNER TO "postgres";
CREATE FUNCTION "halfvec_out"("public"."halfvec")
  RETURNS "pg_catalog"."cstring" AS '$libdir/vector', 'halfvec_out'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "halfvec_out"("public"."halfvec") OWNER TO "postgres";
CREATE FUNCTION "halfvec_recv"(internal, oid, int4)
  RETURNS "public"."halfvec" AS '$libdir/vector', 'halfvec_recv'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "halfvec_recv"(internal, oid, int4) OWNER TO "postgres";
CREATE FUNCTION "halfvec_send"("public"."halfvec")
  RETURNS "pg_catalog"."bytea" AS '$libdir/vector', 'halfvec_send'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "halfvec_send"("public"."halfvec") OWNER TO "postgres";
CREATE FUNCTION "halfvec_spherical_distance"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'halfvec_spherical_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "halfvec_spherical_distance"("public"."halfvec", "public"."halfvec") OWNER TO "postgres";
CREATE FUNCTION "halfvec_sub"("public"."halfvec", "public"."halfvec")
  RETURNS "public"."halfvec" AS '$libdir/vector', 'halfvec_sub'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "halfvec_sub"("public"."halfvec", "public"."halfvec") OWNER TO "postgres";
CREATE FUNCTION "halfvec_to_float4"("public"."halfvec", int4, bool)
  RETURNS "pg_catalog"."_float4" AS '$libdir/vector', 'halfvec_to_float4'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "halfvec_to_float4"("public"."halfvec", int4, bool) OWNER TO "postgres";
CREATE FUNCTION "halfvec_to_sparsevec"("public"."halfvec", int4, bool)
  RETURNS "public"."sparsevec" AS '$libdir/vector', 'halfvec_to_sparsevec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "halfvec_to_sparsevec"("public"."halfvec", int4, bool) OWNER TO "postgres";
CREATE FUNCTION "halfvec_to_vector"("public"."halfvec", int4, bool)
  RETURNS "public"."vector" AS '$libdir/vector', 'halfvec_to_vector'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "halfvec_to_vector"("public"."halfvec", int4, bool) OWNER TO "postgres";
CREATE FUNCTION "halfvec_typmod_in"(_cstring)
  RETURNS "pg_catalog"."int4" AS '$libdir/vector', 'halfvec_typmod_in'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "halfvec_typmod_in"(_cstring) OWNER TO "postgres";
CREATE FUNCTION "hamming_distance"(bit, bit)
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'hamming_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "hamming_distance"(bit, bit) OWNER TO "postgres";
CREATE FUNCTION "hmac"(bytea, bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_hmac'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "hmac"(bytea, bytea, text) OWNER TO "postgres";
CREATE FUNCTION "hmac"(text, text, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_hmac'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "hmac"(text, text, text) OWNER TO "postgres";
CREATE FUNCTION "hnsw_bit_support"(internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/vector', 'hnsw_bit_support'
  LANGUAGE c VOLATILE
  COST 1;
ALTER FUNCTION "hnsw_bit_support"(internal) OWNER TO "postgres";
CREATE FUNCTION "hnsw_halfvec_support"(internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/vector', 'hnsw_halfvec_support'
  LANGUAGE c VOLATILE
  COST 1;
ALTER FUNCTION "hnsw_halfvec_support"(internal) OWNER TO "postgres";
CREATE FUNCTION "hnsw_sparsevec_support"(internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/vector', 'hnsw_sparsevec_support'
  LANGUAGE c VOLATILE
  COST 1;
ALTER FUNCTION "hnsw_sparsevec_support"(internal) OWNER TO "postgres";
CREATE FUNCTION "hnswhandler"(internal)
  RETURNS "pg_catalog"."index_am_handler" AS '$libdir/vector', 'hnswhandler'
  LANGUAGE c VOLATILE
  COST 1;
ALTER FUNCTION "hnswhandler"(internal) OWNER TO "postgres";
CREATE FUNCTION "inner_product"("public"."sparsevec", "public"."sparsevec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'sparsevec_inner_product'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "inner_product"("public"."sparsevec", "public"."sparsevec") OWNER TO "postgres";
CREATE FUNCTION "inner_product"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'inner_product'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "inner_product"("public"."vector", "public"."vector") OWNER TO "postgres";
CREATE FUNCTION "inner_product"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'halfvec_inner_product'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "inner_product"("public"."halfvec", "public"."halfvec") OWNER TO "postgres";
CREATE FUNCTION "ivfflat_bit_support"(internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/vector', 'ivfflat_bit_support'
  LANGUAGE c VOLATILE
  COST 1;
ALTER FUNCTION "ivfflat_bit_support"(internal) OWNER TO "postgres";
CREATE FUNCTION "ivfflat_halfvec_support"(internal)
  RETURNS "pg_catalog"."internal" AS '$libdir/vector', 'ivfflat_halfvec_support'
  LANGUAGE c VOLATILE
  COST 1;
ALTER FUNCTION "ivfflat_halfvec_support"(internal) OWNER TO "postgres";
CREATE FUNCTION "ivfflathandler"(internal)
  RETURNS "pg_catalog"."index_am_handler" AS '$libdir/vector', 'ivfflathandler'
  LANGUAGE c VOLATILE
  COST 1;
ALTER FUNCTION "ivfflathandler"(internal) OWNER TO "postgres";
CREATE FUNCTION "jaccard_distance"(bit, bit)
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'jaccard_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "jaccard_distance"(bit, bit) OWNER TO "postgres";
CREATE FUNCTION "l1_distance"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'halfvec_l1_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "l1_distance"("public"."halfvec", "public"."halfvec") OWNER TO "postgres";
CREATE FUNCTION "l1_distance"("public"."sparsevec", "public"."sparsevec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'sparsevec_l1_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "l1_distance"("public"."sparsevec", "public"."sparsevec") OWNER TO "postgres";
CREATE FUNCTION "l1_distance"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'l1_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "l1_distance"("public"."vector", "public"."vector") OWNER TO "postgres";
CREATE FUNCTION "l2_distance"("public"."sparsevec", "public"."sparsevec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'sparsevec_l2_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "l2_distance"("public"."sparsevec", "public"."sparsevec") OWNER TO "postgres";
CREATE FUNCTION "l2_distance"("public"."halfvec", "public"."halfvec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'halfvec_l2_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "l2_distance"("public"."halfvec", "public"."halfvec") OWNER TO "postgres";
CREATE FUNCTION "l2_distance"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'l2_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "l2_distance"("public"."vector", "public"."vector") OWNER TO "postgres";
CREATE FUNCTION "l2_norm"("public"."halfvec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'halfvec_l2_norm'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "l2_norm"("public"."halfvec") OWNER TO "postgres";
CREATE FUNCTION "l2_norm"("public"."sparsevec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'sparsevec_l2_norm'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "l2_norm"("public"."sparsevec") OWNER TO "postgres";
CREATE FUNCTION "l2_normalize"("public"."sparsevec")
  RETURNS "public"."sparsevec" AS '$libdir/vector', 'sparsevec_l2_normalize'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "l2_normalize"("public"."sparsevec") OWNER TO "postgres";
CREATE FUNCTION "l2_normalize"("public"."vector")
  RETURNS "public"."vector" AS '$libdir/vector', 'l2_normalize'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "l2_normalize"("public"."vector") OWNER TO "postgres";
CREATE FUNCTION "l2_normalize"("public"."halfvec")
  RETURNS "public"."halfvec" AS '$libdir/vector', 'halfvec_l2_normalize'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "l2_normalize"("public"."halfvec") OWNER TO "postgres";
CREATE FUNCTION "pgp_armor_headers"(IN text, OUT "key" text, OUT "value" text)
  RETURNS SETOF "pg_catalog"."record" AS '$libdir/pgcrypto', 'pgp_armor_headers'
  LANGUAGE c IMMUTABLE STRICT
  COST 1
  ROWS 1000;
ALTER FUNCTION "pgp_armor_headers"(text, OUT "key" text, OUT "value" text) OWNER TO "postgres";
CREATE FUNCTION "pgp_key_id"(bytea)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pgp_key_id_w'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "pgp_key_id"(bytea) OWNER TO "postgres";
CREATE FUNCTION "pgp_pub_decrypt"(bytea, bytea, text)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "pgp_pub_decrypt"(bytea, bytea, text) OWNER TO "postgres";
CREATE FUNCTION "pgp_pub_decrypt"(bytea, bytea)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "pgp_pub_decrypt"(bytea, bytea) OWNER TO "postgres";
CREATE FUNCTION "pgp_pub_decrypt"(bytea, bytea, text, text)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "pgp_pub_decrypt"(bytea, bytea, text, text) OWNER TO "postgres";
CREATE FUNCTION "pgp_pub_decrypt_bytea"(bytea, bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "pgp_pub_decrypt_bytea"(bytea, bytea, text) OWNER TO "postgres";
CREATE FUNCTION "pgp_pub_decrypt_bytea"(bytea, bytea)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "pgp_pub_decrypt_bytea"(bytea, bytea) OWNER TO "postgres";
CREATE FUNCTION "pgp_pub_decrypt_bytea"(bytea, bytea, text, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "pgp_pub_decrypt_bytea"(bytea, bytea, text, text) OWNER TO "postgres";
CREATE FUNCTION "pgp_pub_encrypt"(text, bytea)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_pub_encrypt_text'
  LANGUAGE c VOLATILE STRICT
  COST 1;
ALTER FUNCTION "pgp_pub_encrypt"(text, bytea) OWNER TO "postgres";
CREATE FUNCTION "pgp_pub_encrypt"(text, bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_pub_encrypt_text'
  LANGUAGE c VOLATILE STRICT
  COST 1;
ALTER FUNCTION "pgp_pub_encrypt"(text, bytea, text) OWNER TO "postgres";
CREATE FUNCTION "pgp_pub_encrypt_bytea"(bytea, bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_pub_encrypt_bytea'
  LANGUAGE c VOLATILE STRICT
  COST 1;
ALTER FUNCTION "pgp_pub_encrypt_bytea"(bytea, bytea, text) OWNER TO "postgres";
CREATE FUNCTION "pgp_pub_encrypt_bytea"(bytea, bytea)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_pub_encrypt_bytea'
  LANGUAGE c VOLATILE STRICT
  COST 1;
ALTER FUNCTION "pgp_pub_encrypt_bytea"(bytea, bytea) OWNER TO "postgres";
CREATE FUNCTION "pgp_sym_decrypt"(bytea, text)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pgp_sym_decrypt_text'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "pgp_sym_decrypt"(bytea, text) OWNER TO "postgres";
CREATE FUNCTION "pgp_sym_decrypt"(bytea, text, text)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pgp_sym_decrypt_text'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "pgp_sym_decrypt"(bytea, text, text) OWNER TO "postgres";
CREATE FUNCTION "pgp_sym_decrypt_bytea"(bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_sym_decrypt_bytea'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "pgp_sym_decrypt_bytea"(bytea, text) OWNER TO "postgres";
CREATE FUNCTION "pgp_sym_decrypt_bytea"(bytea, text, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_sym_decrypt_bytea'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "pgp_sym_decrypt_bytea"(bytea, text, text) OWNER TO "postgres";
CREATE FUNCTION "pgp_sym_encrypt"(text, text, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_sym_encrypt_text'
  LANGUAGE c VOLATILE STRICT
  COST 1;
ALTER FUNCTION "pgp_sym_encrypt"(text, text, text) OWNER TO "postgres";
CREATE FUNCTION "pgp_sym_encrypt"(text, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_sym_encrypt_text'
  LANGUAGE c VOLATILE STRICT
  COST 1;
ALTER FUNCTION "pgp_sym_encrypt"(text, text) OWNER TO "postgres";
CREATE FUNCTION "pgp_sym_encrypt_bytea"(bytea, text, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_sym_encrypt_bytea'
  LANGUAGE c VOLATILE STRICT
  COST 1;
ALTER FUNCTION "pgp_sym_encrypt_bytea"(bytea, text, text) OWNER TO "postgres";
CREATE FUNCTION "pgp_sym_encrypt_bytea"(bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_sym_encrypt_bytea'
  LANGUAGE c VOLATILE STRICT
  COST 1;
ALTER FUNCTION "pgp_sym_encrypt_bytea"(bytea, text) OWNER TO "postgres";
CREATE FUNCTION "phash_distance"("hash1" text, "hash2" text)
  RETURNS "pg_catalog"."int4" AS $BODY$
DECLARE
    b1 BIT(64);
    b2 BIT(64);
    x  BIT(64);
BEGIN

    b1 := ('x' || hash1)::bit(64);
    b2 := ('x' || hash2)::bit(64);

    x := b1 # b2;

    RETURN length(replace(x::text,'0',''));

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "phash_distance"("hash1" text, "hash2" text) OWNER TO "postgres";
CREATE FUNCTION "phash_hex_to_bit64"("hex" text)
  RETURNS "pg_catalog"."bit" AS $BODY$
SELECT (
  string_agg(
    get_bit(decode(lower(hex),'hex'),i)::text, '' ORDER BY i
  )
)::bit(64)
FROM generate_series(0,63) i
WHERE hex ~ '^[0-9a-fA-F]{16}$';
$BODY$
  LANGUAGE sql IMMUTABLE STRICT
  COST 100;
ALTER FUNCTION "phash_hex_to_bit64"("hex" text) OWNER TO "postgres";
CREATE FUNCTION "phash_hex_to_vector64"("hex_str" text)
  RETURNS "public"."vector" AS $BODY$
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
$BODY$
  LANGUAGE sql IMMUTABLE STRICT
  COST 100;
ALTER FUNCTION "phash_hex_to_vector64"("hex_str" text) OWNER TO "postgres";
CREATE FUNCTION "phash_vector64_to_hex"("v" "public"."vector")
  RETURNS "pg_catalog"."text" AS $BODY$
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
$BODY$
  LANGUAGE plpgsql IMMUTABLE STRICT
  COST 100;
ALTER FUNCTION "phash_vector64_to_hex"("v" "public"."vector") OWNER TO "postgres";
CREATE FUNCTION "process_video_review"("in_video_id" uuid)
  RETURNS TABLE("start_idx" int8, "end_idx" int8, "start_pts" float8, "end_pts" float8, "min_hamming" int4, "max_hamming" int4, "frame_count" int8, "similar_pair_count" int8, "review_idx" int8, "risk_level" text, "has_img_flag" bool) AS $BODY$
WITH frame_dist AS (
    SELECT
        idx,
        pts_time,
        has_image, -- 【修复】使用 has_image 而非 has_png
        bit_count(phash_bits # LAG(phash_bits) OVER(PARTITION BY video_id ORDER BY idx)) AS ham_dist
    FROM video_frames
    WHERE video_id = in_video_id
),
mark_segment AS (
    SELECT
        *,
        CASE WHEN ham_dist > 32 OR ham_dist IS NULL THEN 1 ELSE 0 END AS new_group
    FROM frame_dist
),
group_seg AS (
    SELECT
        *,
        SUM(new_group) OVER(ORDER BY idx) AS group_id
    FROM mark_segment
),
seg_agg AS (
    SELECT
        MIN(idx) AS start_idx,
        MAX(idx) AS end_idx,
        MIN(pts_time) AS start_pts,
        MAX(pts_time) AS end_pts,
        MIN(ham_dist) AS min_hamming,
        MAX(ham_dist) AS max_hamming,
        COUNT(*) AS frame_count,
        COUNT(CASE WHEN ham_dist <= 12 THEN 1 END) AS similar_pair_count,
        MIN(idx) + (MAX(idx)-MIN(idx))/2 AS review_idx,
        CASE WHEN MIN(ham_dist) <=5 THEN '高风险：静态画面，重点审核' ELSE '中风险：画面变化小，建议审核' END AS risk_level,
        BOOL_OR(has_image) AS has_img_flag -- 【修复】使用 has_image
    FROM group_seg
    GROUP BY group_id
)
SELECT *
FROM seg_agg
-- 【关键修改】移除 WHERE similar_pair_count > 0，返回所有分组
ORDER BY start_idx;
$BODY$
  LANGUAGE sql STABLE
  COST 100
  ROWS 1000;
ALTER FUNCTION "process_video_review"("in_video_id" uuid) OWNER TO "postgres";
CREATE FUNCTION "set_update_time_at"()
  RETURNS "pg_catalog"."trigger" AS $BODY$
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "set_update_time_at"() OWNER TO "postgres";
CREATE FUNCTION "set_update_time_at_frames"()
  RETURNS "pg_catalog"."trigger" AS $BODY$
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "set_update_time_at_frames"() OWNER TO "postgres";
CREATE FUNCTION "set_update_time_at_meta"()
  RETURNS "pg_catalog"."trigger" AS $BODY$
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "set_update_time_at_meta"() OWNER TO "postgres";
CREATE FUNCTION "sparsevec"("public"."sparsevec", int4, bool)
  RETURNS "public"."sparsevec" AS '$libdir/vector', 'sparsevec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "sparsevec"("public"."sparsevec", int4, bool) OWNER TO "postgres";
CREATE FUNCTION "sparsevec_cmp"("public"."sparsevec", "public"."sparsevec")
  RETURNS "pg_catalog"."int4" AS '$libdir/vector', 'sparsevec_cmp'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "sparsevec_cmp"("public"."sparsevec", "public"."sparsevec") OWNER TO "postgres";
CREATE FUNCTION "sparsevec_eq"("public"."sparsevec", "public"."sparsevec")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'sparsevec_eq'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "sparsevec_eq"("public"."sparsevec", "public"."sparsevec") OWNER TO "postgres";
CREATE FUNCTION "sparsevec_ge"("public"."sparsevec", "public"."sparsevec")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'sparsevec_ge'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "sparsevec_ge"("public"."sparsevec", "public"."sparsevec") OWNER TO "postgres";
CREATE FUNCTION "sparsevec_gt"("public"."sparsevec", "public"."sparsevec")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'sparsevec_gt'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "sparsevec_gt"("public"."sparsevec", "public"."sparsevec") OWNER TO "postgres";
CREATE FUNCTION "sparsevec_in"(cstring, oid, int4)
  RETURNS "public"."sparsevec" AS '$libdir/vector', 'sparsevec_in'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "sparsevec_in"(cstring, oid, int4) OWNER TO "postgres";
CREATE FUNCTION "sparsevec_l2_squared_distance"("public"."sparsevec", "public"."sparsevec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'sparsevec_l2_squared_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "sparsevec_l2_squared_distance"("public"."sparsevec", "public"."sparsevec") OWNER TO "postgres";
CREATE FUNCTION "sparsevec_le"("public"."sparsevec", "public"."sparsevec")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'sparsevec_le'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "sparsevec_le"("public"."sparsevec", "public"."sparsevec") OWNER TO "postgres";
CREATE FUNCTION "sparsevec_lt"("public"."sparsevec", "public"."sparsevec")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'sparsevec_lt'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "sparsevec_lt"("public"."sparsevec", "public"."sparsevec") OWNER TO "postgres";
CREATE FUNCTION "sparsevec_ne"("public"."sparsevec", "public"."sparsevec")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'sparsevec_ne'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "sparsevec_ne"("public"."sparsevec", "public"."sparsevec") OWNER TO "postgres";
CREATE FUNCTION "sparsevec_negative_inner_product"("public"."sparsevec", "public"."sparsevec")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'sparsevec_negative_inner_product'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "sparsevec_negative_inner_product"("public"."sparsevec", "public"."sparsevec") OWNER TO "postgres";
CREATE FUNCTION "sparsevec_out"("public"."sparsevec")
  RETURNS "pg_catalog"."cstring" AS '$libdir/vector', 'sparsevec_out'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "sparsevec_out"("public"."sparsevec") OWNER TO "postgres";
CREATE FUNCTION "sparsevec_recv"(internal, oid, int4)
  RETURNS "public"."sparsevec" AS '$libdir/vector', 'sparsevec_recv'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "sparsevec_recv"(internal, oid, int4) OWNER TO "postgres";
CREATE FUNCTION "sparsevec_send"("public"."sparsevec")
  RETURNS "pg_catalog"."bytea" AS '$libdir/vector', 'sparsevec_send'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "sparsevec_send"("public"."sparsevec") OWNER TO "postgres";
CREATE FUNCTION "sparsevec_to_halfvec"("public"."sparsevec", int4, bool)
  RETURNS "public"."halfvec" AS '$libdir/vector', 'sparsevec_to_halfvec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "sparsevec_to_halfvec"("public"."sparsevec", int4, bool) OWNER TO "postgres";
CREATE FUNCTION "sparsevec_to_vector"("public"."sparsevec", int4, bool)
  RETURNS "public"."vector" AS '$libdir/vector', 'sparsevec_to_vector'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "sparsevec_to_vector"("public"."sparsevec", int4, bool) OWNER TO "postgres";
CREATE FUNCTION "sparsevec_typmod_in"(_cstring)
  RETURNS "pg_catalog"."int4" AS '$libdir/vector', 'sparsevec_typmod_in'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "sparsevec_typmod_in"(_cstring) OWNER TO "postgres";
CREATE FUNCTION "subvector"("public"."vector", int4, int4)
  RETURNS "public"."vector" AS '$libdir/vector', 'subvector'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "subvector"("public"."vector", int4, int4) OWNER TO "postgres";
CREATE FUNCTION "subvector"("public"."halfvec", int4, int4)
  RETURNS "public"."halfvec" AS '$libdir/vector', 'halfvec_subvector'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "subvector"("public"."halfvec", int4, int4) OWNER TO "postgres";
CREATE FUNCTION "toTimestamptz"("value" text)
  RETURNS "pg_catalog"."timestamptz" AS $BODY$
    SELECT value::timestamptz;
$BODY$
  LANGUAGE sql IMMUTABLE STRICT
  COST 100;
ALTER FUNCTION "toTimestamptz"("value" text) OWNER TO "postgres";
CREATE FUNCTION "to_bigint"("input_str" text)
  RETURNS "pg_catalog"."int8" AS $BODY$
BEGIN
  IF btrim(input_str) = '' THEN RETURN NULL; END IF;
  RETURN btrim(input_str)::bigint;
EXCEPTION WHEN OTHERS THEN RETURN NULL;
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE STRICT
  COST 100;
ALTER FUNCTION "to_bigint"("input_str" text) OWNER TO "postgres";
CREATE FUNCTION "to_int"("input_str" text)
  RETURNS "pg_catalog"."int4" AS $BODY$
BEGIN
  IF btrim(input_str) = '' THEN RETURN NULL; END IF;
  RETURN btrim(input_str)::int;
EXCEPTION WHEN OTHERS THEN RETURN NULL;
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE STRICT
  COST 100;
ALTER FUNCTION "to_int"("input_str" text) OWNER TO "postgres";
CREATE FUNCTION "to_numeric"("input_str" text)
  RETURNS "pg_catalog"."numeric" AS $BODY$
BEGIN
  IF btrim(input_str) = '' THEN RETURN NULL; END IF;
  RETURN btrim(input_str)::numeric;
EXCEPTION WHEN OTHERS THEN RETURN NULL;
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE STRICT
  COST 100;
ALTER FUNCTION "to_numeric"("input_str" text) OWNER TO "postgres";
CREATE FUNCTION "to_timestamptz"("input_str" text)
  RETURNS "pg_catalog"."timestamptz" AS $BODY$
BEGIN
  IF btrim(input_str) = '' THEN RETURN NULL; END IF;
  RETURN btrim(input_str)::timestamptz;
EXCEPTION WHEN OTHERS THEN RETURN NULL;
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE STRICT
  COST 100;
ALTER FUNCTION "to_timestamptz"("input_str" text) OWNER TO "postgres";
CREATE FUNCTION "to_uuid"("input_str" text)
  RETURNS "pg_catalog"."uuid" AS $BODY$
BEGIN
  IF btrim(input_str) = '' THEN RETURN NULL; END IF;
  RETURN btrim(input_str)::uuid;
EXCEPTION WHEN OTHERS THEN RETURN NULL;
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE STRICT
  COST 100;
ALTER FUNCTION "to_uuid"("input_str" text) OWNER TO "postgres";
CREATE FUNCTION "uuid_generate_v1"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v1'
  LANGUAGE c VOLATILE STRICT
  COST 1;
ALTER FUNCTION "uuid_generate_v1"() OWNER TO "postgres";
CREATE FUNCTION "uuid_generate_v1mc"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v1mc'
  LANGUAGE c VOLATILE STRICT
  COST 1;
ALTER FUNCTION "uuid_generate_v1mc"() OWNER TO "postgres";
CREATE FUNCTION "uuid_generate_v3"("namespace" uuid, "name" text)
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v3'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "uuid_generate_v3"("namespace" uuid, "name" text) OWNER TO "postgres";
CREATE FUNCTION "uuid_generate_v4"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v4'
  LANGUAGE c VOLATILE STRICT
  COST 1;
ALTER FUNCTION "uuid_generate_v4"() OWNER TO "postgres";
CREATE FUNCTION "uuid_generate_v5"("namespace" uuid, "name" text)
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v5'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "uuid_generate_v5"("namespace" uuid, "name" text) OWNER TO "postgres";
CREATE FUNCTION "uuid_nil"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_nil'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "uuid_nil"() OWNER TO "postgres";
CREATE FUNCTION "uuid_ns_dns"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_dns'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "uuid_ns_dns"() OWNER TO "postgres";
CREATE FUNCTION "uuid_ns_oid"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_oid'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "uuid_ns_oid"() OWNER TO "postgres";
CREATE FUNCTION "uuid_ns_url"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_url'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "uuid_ns_url"() OWNER TO "postgres";
CREATE FUNCTION "uuid_ns_x500"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_x500'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "uuid_ns_x500"() OWNER TO "postgres";
CREATE FUNCTION "vector"("public"."vector", int4, bool)
  RETURNS "public"."vector" AS '$libdir/vector', 'vector'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector"("public"."vector", int4, bool) OWNER TO "postgres";
CREATE FUNCTION "vector_accum"(_float8, "public"."vector")
  RETURNS "pg_catalog"."_float8" AS '$libdir/vector', 'vector_accum'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_accum"(_float8, "public"."vector") OWNER TO "postgres";
CREATE FUNCTION "vector_add"("public"."vector", "public"."vector")
  RETURNS "public"."vector" AS '$libdir/vector', 'vector_add'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_add"("public"."vector", "public"."vector") OWNER TO "postgres";
CREATE FUNCTION "vector_avg"(_float8)
  RETURNS "public"."vector" AS '$libdir/vector', 'vector_avg'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_avg"(_float8) OWNER TO "postgres";
CREATE FUNCTION "vector_cmp"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."int4" AS '$libdir/vector', 'vector_cmp'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_cmp"("public"."vector", "public"."vector") OWNER TO "postgres";
CREATE FUNCTION "vector_combine"(_float8, _float8)
  RETURNS "pg_catalog"."_float8" AS '$libdir/vector', 'vector_combine'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_combine"(_float8, _float8) OWNER TO "postgres";
CREATE FUNCTION "vector_concat"("public"."vector", "public"."vector")
  RETURNS "public"."vector" AS '$libdir/vector', 'vector_concat'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_concat"("public"."vector", "public"."vector") OWNER TO "postgres";
CREATE FUNCTION "vector_dims"("public"."vector")
  RETURNS "pg_catalog"."int4" AS '$libdir/vector', 'vector_dims'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_dims"("public"."vector") OWNER TO "postgres";
CREATE FUNCTION "vector_dims"("public"."halfvec")
  RETURNS "pg_catalog"."int4" AS '$libdir/vector', 'halfvec_vector_dims'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_dims"("public"."halfvec") OWNER TO "postgres";
CREATE FUNCTION "vector_eq"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'vector_eq'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_eq"("public"."vector", "public"."vector") OWNER TO "postgres";
CREATE FUNCTION "vector_ge"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'vector_ge'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_ge"("public"."vector", "public"."vector") OWNER TO "postgres";
CREATE FUNCTION "vector_gt"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'vector_gt'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_gt"("public"."vector", "public"."vector") OWNER TO "postgres";
CREATE FUNCTION "vector_in"(cstring, oid, int4)
  RETURNS "public"."vector" AS '$libdir/vector', 'vector_in'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_in"(cstring, oid, int4) OWNER TO "postgres";
CREATE FUNCTION "vector_l2_squared_distance"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'vector_l2_squared_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_l2_squared_distance"("public"."vector", "public"."vector") OWNER TO "postgres";
CREATE FUNCTION "vector_le"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'vector_le'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_le"("public"."vector", "public"."vector") OWNER TO "postgres";
CREATE FUNCTION "vector_lt"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'vector_lt'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_lt"("public"."vector", "public"."vector") OWNER TO "postgres";
CREATE FUNCTION "vector_mul"("public"."vector", "public"."vector")
  RETURNS "public"."vector" AS '$libdir/vector', 'vector_mul'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_mul"("public"."vector", "public"."vector") OWNER TO "postgres";
CREATE FUNCTION "vector_ne"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."bool" AS '$libdir/vector', 'vector_ne'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_ne"("public"."vector", "public"."vector") OWNER TO "postgres";
CREATE FUNCTION "vector_negative_inner_product"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'vector_negative_inner_product'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_negative_inner_product"("public"."vector", "public"."vector") OWNER TO "postgres";
CREATE FUNCTION "vector_norm"("public"."vector")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'vector_norm'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_norm"("public"."vector") OWNER TO "postgres";
CREATE FUNCTION "vector_out"("public"."vector")
  RETURNS "pg_catalog"."cstring" AS '$libdir/vector', 'vector_out'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_out"("public"."vector") OWNER TO "postgres";
CREATE FUNCTION "vector_recv"(internal, oid, int4)
  RETURNS "public"."vector" AS '$libdir/vector', 'vector_recv'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_recv"(internal, oid, int4) OWNER TO "postgres";
CREATE FUNCTION "vector_send"("public"."vector")
  RETURNS "pg_catalog"."bytea" AS '$libdir/vector', 'vector_send'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_send"("public"."vector") OWNER TO "postgres";
CREATE FUNCTION "vector_spherical_distance"("public"."vector", "public"."vector")
  RETURNS "pg_catalog"."float8" AS '$libdir/vector', 'vector_spherical_distance'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_spherical_distance"("public"."vector", "public"."vector") OWNER TO "postgres";
CREATE FUNCTION "vector_sub"("public"."vector", "public"."vector")
  RETURNS "public"."vector" AS '$libdir/vector', 'vector_sub'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_sub"("public"."vector", "public"."vector") OWNER TO "postgres";
CREATE FUNCTION "vector_to_float4"("public"."vector", int4, bool)
  RETURNS "pg_catalog"."_float4" AS '$libdir/vector', 'vector_to_float4'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_to_float4"("public"."vector", int4, bool) OWNER TO "postgres";
CREATE FUNCTION "vector_to_halfvec"("public"."vector", int4, bool)
  RETURNS "public"."halfvec" AS '$libdir/vector', 'vector_to_halfvec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_to_halfvec"("public"."vector", int4, bool) OWNER TO "postgres";
CREATE FUNCTION "vector_to_sparsevec"("public"."vector", int4, bool)
  RETURNS "public"."sparsevec" AS '$libdir/vector', 'vector_to_sparsevec'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_to_sparsevec"("public"."vector", int4, bool) OWNER TO "postgres";
CREATE FUNCTION "vector_typmod_in"(_cstring)
  RETURNS "pg_catalog"."int4" AS '$libdir/vector', 'vector_typmod_in'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "vector_typmod_in"(_cstring) OWNER TO "postgres";
BEGIN;
LOCK TABLE "public"."activity_execution" IN SHARE MODE;
DELETE FROM "public"."activity_execution";
INSERT INTO "public"."activity_execution" ("id","activity_name","idempotency_key","status","result","raw_request","error_message","create_time_at","completed_at") VALUES ('a3637de7-b6be-4185-a7e5-f85cceeafb25', 'probeVideoActivity', 'probe-84cf62d0903b9a5b', 'RUNNING', NULL, '{}', NULL, '2026-09-19 06:16:27.710869+00', NULL),('d285243d-ea12-4c1c-a467-a5446f554b4d', 'probeVideoActivity', 'probe-2c0d0272c72a6813', 'RUNNING', NULL, '{}', NULL, '2026-09-19 06:17:44.460947+00', NULL),('5278552e-a6e9-450c-9d17-a0907b2f6bc7', 'probeVideoActivity', 'probe-4757b51b2a996189', 'RUNNING', NULL, '{}', NULL, '2026-09-19 06:21:28.490465+00', NULL),('7df5f5c4-cb5e-40d2-ab25-001ce0abd1c0', 'probeVideoActivity', 'probe-605379759a6a2dc7', 'RUNNING', NULL, '{}', NULL, '2026-09-19 09:13:16.927224+00', NULL),('bbb442d9-b027-4250-8add-138d91c974b4', 'probeVideoActivity', 'probe-aebb8bd04887ca6f', 'RUNNING', NULL, '{}', NULL, '2026-09-19 12:27:08.986067+00', NULL),('a07c09a9-9c69-4819-84d5-6d6c9ef26606', 'probeVideoActivity', 'probe-35b4c02433723560', 'RUNNING', NULL, '{}', NULL, '2026-09-19 13:24:41.446695+00', NULL),('2d67c1fa-5495-4c8c-baed-402047d22b39', 'probeVideoActivity', 'probe-7ce92c7742214265', 'RUNNING', NULL, '{}', NULL, '2026-09-19 14:04:43.159693+00', NULL)
;
COMMIT;
BEGIN;
LOCK TABLE "public"."analysis_result" IN SHARE MODE;
DELETE FROM "public"."analysis_result";
COMMIT;
BEGIN;
LOCK TABLE "public"."asset" IN SHARE MODE;
DELETE FROM "public"."asset";
COMMIT;
BEGIN;
LOCK TABLE "public"."face_detection" IN SHARE MODE;
DELETE FROM "public"."face_detection";
COMMIT;
BEGIN;
LOCK TABLE "public"."ocr_result" IN SHARE MODE;
DELETE FROM "public"."ocr_result";
COMMIT;
BEGIN;
LOCK TABLE "public"."review_risk" IN SHARE MODE;
DELETE FROM "public"."review_risk";
INSERT INTO "public"."review_risk" ("id","risk_code","risk_name","risk_level","description","is_active","create_at") VALUES ('619eddee-397e-4382-b97f-b5d6ab6f0787', 'vulgar', '??', 2, '?????????', 't', '2026-09-20 01:53:53.054314+00'),('58affb5f-8400-41b7-a37b-71d89fc1ea68', 'nudity', '??', 1, '???????', 't', '2026-09-20 01:53:53.054314+00'),('6ce94e9e-6e85-4309-ac4d-9944cca4a3b0', 'bad_tendency', '????', 2, '??????????', 't', '2026-09-20 01:53:53.054314+00'),('863f0c20-d675-4934-a4a5-f66066be1b38', 'violence', '??', 1, '??????', 't', '2026-09-20 01:53:53.054314+00'),('eeba6b77-d1f6-42cd-8221-37c7e6395bd7', 'politics', '??', 1, '??????', 't', '2026-09-20 01:53:53.054314+00'),('88341c7c-f8a9-4c12-9a10-9c23231b00f8', 'ad_watermark', '????', 3, '???????', 't', '2026-09-20 01:53:53.054314+00')
;
COMMIT;
BEGIN;
LOCK TABLE "public"."subtitle" IN SHARE MODE;
DELETE FROM "public"."subtitle";
COMMIT;
BEGIN;
LOCK TABLE "public"."task_checkpoint" IN SHARE MODE;
DELETE FROM "public"."task_checkpoint";
COMMIT;
BEGIN;
LOCK TABLE "public"."video_frames" IN SHARE MODE;
DELETE FROM "public"."video_frames";
COMMIT;
BEGIN;
LOCK TABLE "public"."video_meta" IN SHARE MODE;
DELETE FROM "public"."video_meta";
INSERT INTO "public"."video_meta" ("id","raw","file_hash","is_valid","last_modified","status","processed_at","scene_count","frame_count","error_message","create_time_at","update_time_at") VALUES ('9c8ba154-ad0e-494c-a63b-4f3cbd2254c7', '{"fileInfo": {"atime": "2026-09-19T13:34:30.379Z", "mtime": "2026-07-24T19:30:41.310Z", "fileName": "你是不是没吃药.mp4", "filePath": "你是不是没吃药.mp4", "fileSize": 3844284, "birthTime": "2026-07-25T01:55:29.622Z"}, "videoInfo": {"fps": 24, "codec": "h264", "width": 480, "format": "unknown", "height": 854, "duration": 62.486, "fileSize": 0}}', '5L2g5piv5LiN5piv5rKh5ZCD6I2vLm1wNA==', 't', NULL, NULL, NULL, NULL, NULL, NULL, '2026-09-20 01:56:04.682179+00', '2026-09-20 01:56:04.682179+00')
;
COMMIT;
BEGIN;
LOCK TABLE "public"."video_process_stage" IN SHARE MODE;
DELETE FROM "public"."video_process_stage";
COMMIT;
BEGIN;
LOCK TABLE "public"."video_segment" IN SHARE MODE;
DELETE FROM "public"."video_segment";
COMMIT;
BEGIN;
LOCK TABLE "public"."video_task" IN SHARE MODE;
DELETE FROM "public"."video_task";
COMMIT;
ALTER TABLE "activity_execution" ADD CONSTRAINT "activity_execution_pkey" PRIMARY KEY ("id");
CREATE INDEX "idx_activity_raw_gin" ON "activity_execution" USING gin (
  "raw_request" "pg_catalog"."jsonb_ops"
);
CREATE INDEX "idx_execution_activity" ON "activity_execution" USING btree (
  "activity_name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_execution_idempotency" ON "activity_execution" USING btree (
  "idempotency_key" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
ALTER TABLE "analysis_result" ADD CONSTRAINT "analysis_result_pkey" PRIMARY KEY ("id");
CREATE INDEX "idx_analysis_asset" ON "analysis_result" USING btree (
  "asset_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "idx_analysis_frame" ON "analysis_result" USING btree (
  "asset_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "frame_idx" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_analysis_raw_gin" ON "analysis_result" USING gin (
  "raw" "pg_catalog"."jsonb_ops"
);
CREATE INDEX "idx_analysis_result_gin" ON "analysis_result" USING gin (
  "result" "pg_catalog"."jsonb_ops"
);
CREATE INDEX "idx_analysis_type" ON "analysis_result" USING btree (
  "analysis_type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
ALTER TABLE "asset" ADD CONSTRAINT "asset_pkey" PRIMARY KEY ("id");
CREATE INDEX "idx_asset_hash" ON "asset" USING btree (
  "file_hash" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_asset_raw_gin" ON "asset" USING gin (
  "raw" "pg_catalog"."jsonb_ops"
);
CREATE INDEX "idx_asset_type" ON "asset" USING btree (
  "type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
ALTER TABLE "face_detection" ADD CONSTRAINT "face_detection_pkey" PRIMARY KEY ("id");
CREATE INDEX "idx_face_embedding_hnsw" ON "face_detection" USING hnsw (
  "face_embedding" "public"."vector_cosine_ops"
) WHERE face_embedding IS NOT NULL;
CREATE INDEX "idx_face_frame_idx" ON "face_detection" USING btree (
  "video_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "frame_idx" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_face_person_id" ON "face_detection" USING btree (
  "person_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "idx_face_raw_gin" ON "face_detection" USING gin (
  "raw" "pg_catalog"."jsonb_ops"
);
CREATE INDEX "idx_face_video_id" ON "face_detection" USING btree (
  "video_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
ALTER TABLE "ocr_result" ADD CONSTRAINT "ocr_result_pkey" PRIMARY KEY ("id");
CREATE INDEX "idx_ocr_raw_gin" ON "ocr_result" USING gin (
  "raw" "pg_catalog"."jsonb_ops"
);
CREATE INDEX "idx_ocr_text_gin" ON "ocr_result" USING gin (
  to_tsvector('simple'::regconfig, text) "pg_catalog"."tsvector_ops"
);
CREATE UNIQUE INDEX "idx_ocr_unique" ON "ocr_result" USING btree (
  "video_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "frame_idx" "pg_catalog"."int4_ops" ASC NULLS LAST,
  "region_hash" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_ocr_video_id" ON "ocr_result" USING btree (
  "video_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
ALTER TABLE "review_risk" ADD CONSTRAINT "review_risk_pkey" PRIMARY KEY ("id");
ALTER TABLE "subtitle" ADD CONSTRAINT "subtitle_pkey" PRIMARY KEY ("id");
CREATE INDEX "idx_subtitle_raw_gin" ON "subtitle" USING gin (
  "raw" "pg_catalog"."jsonb_ops"
);
CREATE INDEX "idx_subtitle_text_gin" ON "subtitle" USING gin (
  to_tsvector('simple'::regconfig, text) "pg_catalog"."tsvector_ops"
);
CREATE INDEX "idx_subtitle_time" ON "subtitle" USING btree (
  "video_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "start_time" "pg_catalog"."numeric_ops" ASC NULLS LAST,
  "end_time" "pg_catalog"."numeric_ops" ASC NULLS LAST
);
CREATE INDEX "idx_subtitle_video_id" ON "subtitle" USING btree (
  "video_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
ALTER TABLE "task_checkpoint" ADD CONSTRAINT "task_checkpoint_pkey" PRIMARY KEY ("id");
CREATE INDEX "idx_checkpoint_raw_gin" ON "task_checkpoint" USING gin (
  "raw" "pg_catalog"."jsonb_ops"
);
ALTER TABLE "video_frames" ADD CONSTRAINT "video_frames_pkey" PRIMARY KEY ("id");
CREATE INDEX "idx_video_frames_frame_type" ON "video_frames" USING btree (
  "frame_type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_video_frames_phash_exact" ON "video_frames" USING btree (
  "phash_vec" "public"."vector_ops" ASC NULLS LAST
) WHERE phash_vec IS NOT NULL;
CREATE INDEX "idx_video_frames_phash_hnsw" ON "video_frames" USING hnsw (
  "phash_vec" "public"."vector_l2_ops"
) WHERE phash_vec IS NOT NULL;
CREATE INDEX "idx_video_frames_vid_idx" ON "video_frames" USING btree (
  "video_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "idx" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_video_frames_vid_pts" ON "video_frames" USING btree (
  "video_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "pts_time" "pg_catalog"."numeric_ops" ASC NULLS LAST
);
CREATE INDEX "idx_video_frames_workflow_id" ON "video_frames" USING btree (
  "workflow_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
) WHERE workflow_id IS NOT NULL;
ALTER TABLE "video_meta" ADD CONSTRAINT "video_meta_pkey" PRIMARY KEY ("id");
CREATE UNIQUE INDEX "idx_video_meta_file_hash" ON "video_meta" USING btree (
  "file_hash" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_video_meta_is_valid" ON "video_meta" USING btree (
  "is_valid" "pg_catalog"."bool_ops" ASC NULLS LAST
);
CREATE INDEX "idx_video_meta_phash_hnsw" ON "video_meta" USING hnsw (
  "video_phash_vec" "public"."vector_l2_ops"
) WHERE video_phash_vec IS NOT NULL;
CREATE INDEX "idx_video_meta_processed_at" ON "video_meta" USING btree (
  "processed_at" "pg_catalog"."timestamptz_ops" DESC NULLS FIRST
);
CREATE INDEX "idx_video_meta_status" ON "video_meta" USING btree (
  "status" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
ALTER TABLE "video_process_stage" ADD CONSTRAINT "video_process_stage_pkey" PRIMARY KEY ("id");
CREATE INDEX "idx_stage_raw_gin" ON "video_process_stage" USING gin (
  "raw" "pg_catalog"."jsonb_ops"
);
CREATE INDEX "idx_stage_status" ON "video_process_stage" USING btree (
  "status" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "idx_stage_unique" ON "video_process_stage" USING btree (
  "video_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "stage" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_stage_video_id" ON "video_process_stage" USING btree (
  "video_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
ALTER TABLE "video_segment" ADD CONSTRAINT "video_segment_pkey" PRIMARY KEY ("id");
CREATE INDEX "idx_segment_raw_gin" ON "video_segment" USING gin (
  "raw" "pg_catalog"."jsonb_ops"
);
CREATE INDEX "idx_segment_time" ON "video_segment" USING btree (
  "video_id" "pg_catalog"."uuid_ops" ASC NULLS LAST,
  "start_time" "pg_catalog"."numeric_ops" ASC NULLS LAST,
  "end_time" "pg_catalog"."numeric_ops" ASC NULLS LAST
);
CREATE INDEX "idx_segment_type" ON "video_segment" USING btree (
  "segment_type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_segment_video_id" ON "video_segment" USING btree (
  "video_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
ALTER TABLE "video_task" ADD CONSTRAINT "video_task_pkey" PRIMARY KEY ("id");
CREATE INDEX "idx_task_raw_gin" ON "video_task" USING gin (
  "raw" "pg_catalog"."jsonb_ops"
);
CREATE INDEX "idx_task_status" ON "video_task" USING btree (
  "status" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_task_video_id" ON "video_task" USING btree (
  "video_id" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "idx_task_workflow_id" ON "video_task" USING btree (
  "workflow_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
ALTER TABLE "activity_execution" ADD CONSTRAINT "activity_execution_activity_name_idempotency_key_key" UNIQUE ("activity_name", "idempotency_key");
ALTER TABLE "activity_execution" ADD CONSTRAINT "activity_execution_status_check" CHECK (status::text = ANY (ARRAY['RUNNING'::character varying, 'SUCCESS'::character varying, 'FAILED'::character varying]::text[]));
ALTER TABLE "analysis_result" ADD CONSTRAINT "chk_analysis_confidence" CHECK (confidence >= 0::numeric AND confidence <= 1::numeric);
ALTER TABLE "analysis_result" ADD CONSTRAINT "analysis_result_asset_id_fkey" FOREIGN KEY ("asset_id") REFERENCES "asset" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
CREATE TRIGGER "trigger_asset_update" BEFORE UPDATE ON "asset"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_update_time_at"();
ALTER TABLE "face_detection" ADD CONSTRAINT "chk_face_confidence" CHECK (confidence >= 0::numeric AND confidence <= 1::numeric);
ALTER TABLE "ocr_result" ADD CONSTRAINT "chk_ocr_confidence" CHECK (confidence >= 0::numeric AND confidence <= 1::numeric);
ALTER TABLE "review_risk" ADD CONSTRAINT "review_risk_risk_code_key" UNIQUE ("risk_code");
ALTER TABLE "subtitle" ADD CONSTRAINT "chk_subtitle_time" CHECK (end_time >= start_time AND start_time >= 0::numeric);
CREATE TRIGGER "trigger_subtitle_update" BEFORE UPDATE ON "subtitle"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_update_time_at"();
ALTER TABLE "task_checkpoint" ADD CONSTRAINT "task_checkpoint_video_id_stage_key" UNIQUE ("video_id", "stage");
CREATE TRIGGER "trigger_task_checkpoint_update" BEFORE UPDATE ON "task_checkpoint"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_update_time_at"();
ALTER TABLE "video_frames" ADD CONSTRAINT "video_frames_video_id_idx_key" UNIQUE ("video_id", "idx");
ALTER TABLE "video_frames" ADD CONSTRAINT "video_frames_pts_time_check" CHECK (pts_time >= 0::numeric);
ALTER TABLE "video_frames" ADD CONSTRAINT "video_frames_idx_check" CHECK (idx >= 0);
ALTER TABLE "video_frames" ADD CONSTRAINT "video_frames_video_id_fkey" FOREIGN KEY ("video_id") REFERENCES "video_meta" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TRIGGER "trigger_video_frames_update" BEFORE UPDATE ON "video_frames"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_update_time_at"();
CREATE TRIGGER "trigger_video_meta_update" BEFORE UPDATE ON "video_meta"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_update_time_at_meta"();
ALTER TABLE "video_process_stage" ADD CONSTRAINT "video_process_stage_stage_check" CHECK (stage::text = ANY (ARRAY['IMPORT'::character varying, 'FRAME'::character varying, 'OCR'::character varying, 'SEGMENT'::character varying, 'FACE'::character varying, 'REVIEW'::character varying, 'EDIT'::character varying]::text[]));
ALTER TABLE "video_process_stage" ADD CONSTRAINT "video_process_stage_status_check" CHECK (status::text = ANY (ARRAY['PENDING'::character varying, 'RUNNING'::character varying, 'DONE'::character varying, 'FAILED'::character varying, 'SKIPPED'::character varying]::text[]));
ALTER TABLE "video_process_stage" ADD CONSTRAINT "video_process_stage_progress_check" CHECK (progress >= 0::numeric AND progress <= 1::numeric);
CREATE TRIGGER "trigger_video_process_stage_update" BEFORE UPDATE ON "video_process_stage"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_update_time_at"();
ALTER TABLE "video_segment" ADD CONSTRAINT "chk_segment_confidence" CHECK (confidence >= 0::numeric AND confidence <= 1::numeric);
ALTER TABLE "video_segment" ADD CONSTRAINT "chk_segment_time" CHECK (end_time >= start_time AND start_time >= 0::numeric);
CREATE TRIGGER "trigger_video_segment_update" BEFORE UPDATE ON "video_segment"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_update_time_at"();
ALTER TABLE "video_task" ADD CONSTRAINT "video_task_status_check" CHECK (status::text = ANY (ARRAY['PENDING'::character varying, 'IMPORTING'::character varying, 'ANALYZING'::character varying, 'REVIEWING'::character varying, 'EDITING'::character varying, 'DONE'::character varying, 'FAILED'::character varying]::text[]));
ALTER TABLE "video_task" ADD CONSTRAINT "video_task_progress_check" CHECK (progress >= 0::numeric AND progress <= 1::numeric);
CREATE TRIGGER "trigger_video_task_update" BEFORE UPDATE ON "video_task"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_update_time_at"();
