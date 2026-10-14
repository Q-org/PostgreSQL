/*
================================================================================
DB Schema: Video Review / AI Analysis
Version: RC10.12
Updated: 2026‑10‑02
Compatibility: PostgreSQL 14+

【表设计说明】
1. analysis_result AI帧分析结果表
    - 核心存储：raw(jsonb)保存完整AI原始输出，业务字段全部为 GENERATED ALWAYS STORED 计算列，
      业务层只写入raw，派生字段不手动维护，保证单一数据源。
    - 主键id(uuid)，外键关联 video_frames(video_id,pts_time)；
      唯一约束 uk_analysis_frame_risk(video_id,pts_time,risk_id) 防止同一风险重复上报同一帧。
    - row_version 乐观锁，更新自动自增，用于并发更新控制。
    - confidence做值域约束 0~1。

2. video_review_platform 多平台视频审核主表
    - 视频维度审核单；video_id 外键指向 video_meta.id（主表主键名id，本表字段统一命名video_id）。
    - platform枚举：bilibili/douyin/kuaishou；version_tag区分同一个视频多次审核版本。
    - submit_time 提交时间不可修改；仅当result状态变更自动刷新 status_updated_at；任何更新刷新updated_at。
    - uk_review_video_platform_version：视频+平台+版本标签唯一，避免重复审核单。
    - row_version乐观锁。

3. video_review_platform_history 审计变更历史表
    - AFTER UPDATE触发器自动写入，业务代码禁止直接操作此表。
    - 记录result、时间、版本号新旧快照，实现审核全流程可溯源。

依赖存量表（脚本不会改动）：
    video_meta(id uuid PK)
    video_frames(video_id uuid, pts_time numeric, PK(video_id,pts_time))

枚举：
    video_review_result：pending待审核 / reviewing审核中 / pass通过 / reject驳回
    review_platform：bilibili / douyin / kuaishou

注意：
  1. 非幂等脚本，初始化使用，生产环境请勿重复执行。
  2. 审计函数建议事后切换owner至独立审计账号做最小权限管控。
  3. 清理顺序：先删除业务表，再删除枚举类型，规避枚举被字段依赖报错。
================================================================================
*/

ROLLBACK;

BEGIN;

-- 第一步：先删表（表依赖枚举，必须优先删表）
DROP TRIGGER IF EXISTS trg_vrp_before_update ON public.video_review_platform;
DROP TRIGGER IF EXISTS trg_vrp_after_update_audit ON public.video_review_platform;
DROP TRIGGER IF EXISTS trg_analysis_before_update ON public.analysis_result;

DROP FUNCTION IF EXISTS public.fn_vrp_enforce_fields();
DROP FUNCTION IF EXISTS public.fn_capture_vrp_audit_history();
DROP FUNCTION IF EXISTS public.fn_analysis_result_inc_rowver();

DROP TABLE IF EXISTS public.video_review_platform_history;
DROP TABLE IF EXISTS public.video_review_platform;
DROP TABLE IF EXISTS public.analysis_result;

-- 第二步：表已经删除，现在可以安全删除枚举类型
DROP TYPE IF EXISTS public.video_review_result;
DROP TYPE IF EXISTS public.review_platform;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 创建枚举
CREATE TYPE public.video_review_result AS ENUM ('pending','reviewing','pass','reject');
CREATE TYPE public.review_platform AS ENUM ('bilibili','douyin','kuaishou');

-- analysis_result AI帧分析结果表
CREATE TABLE public.analysis_result (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    raw jsonb NOT NULL,
    video_id        uuid        GENERATED ALWAYS AS ((raw ->> 'video_id')::uuid) STORED,
    pts_time        numeric     GENERATED ALWAYS AS ((raw ->> 'pts_time')::numeric) STORED,
    risk_id         uuid        GENERATED ALWAYS AS ((raw ->> 'risk_id')::uuid) STORED,
    analysis_type   varchar(64) GENERATED ALWAYS AS (raw ->> 'analysis_type') STORED,
    model_name      varchar(100)GENERATED ALWAYS AS (raw ->> 'model_name') STORED,
    payload_result  jsonb       GENERATED ALWAYS AS (raw -> 'result') STORED,
    note text GENERATED ALWAYS AS ( raw ->> 'note' ) STORED, -- 新增备注字段
    
    confidence numeric(6,5) GENERATED ALWAYS AS (
        CASE WHEN raw->>'confidence' ~ '^[+-]?\d+(\.\d+)?$' THEN (raw->>'confidence')::numeric ELSE NULL END
    ) STORED,
    created_at timestamptz NOT NULL DEFAULT now(),
    row_version bigint NOT NULL DEFAULT 1,

    CONSTRAINT uk_analysis_frame_risk UNIQUE (video_id, pts_time, risk_id),
    CONSTRAINT ck_confidence CHECK (confidence IS NULL OR (confidence >= 0 AND confidence <= 1)),
    CONSTRAINT ck_raw_is_object CHECK (jsonb_typeof(raw) = 'object'),
    CONSTRAINT ck_ar_rowver_positive CHECK (row_version > 0),

    CONSTRAINT fk_analysis_video_frame
        FOREIGN KEY (video_id, pts_time)
        REFERENCES public.video_frames (video_id, pts_time)
        ON DELETE RESTRICT
);

-- CREATE UNIQUE INDEX IF NOT EXISTS uk_analysis_result_vid_pts_risk
-- ON analysis_result(video_id, pts_time, risk_id);

-- CREATE UNIQUE INDEX  uk_video_frame_risk_idx 
-- ON video_frames(video_id, pts_time, risk_id);

ALTER TABLE frame_edge DROP CONSTRAINT IF EXISTS fk_edge_a_real;

ALTER TABLE public.analysis_result
DROP  COLUMN IF EXISTS note;
ALTER TABLE public.analysis_result
ADD COLUMN IF NOT EXISTS note text GENERATED ALWAYS AS ( raw ->> 'note' ) STORED;

-- CREATE INDEX idx_analysis_frame_time ON public.analysis_result (video_id, pts_time);

CREATE OR REPLACE FUNCTION public.fn_analysis_result_inc_rowver()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF OLD.row_version = 9223372036854775807 THEN
        RAISE EXCEPTION 'analysis_result row_version overflow, id=%', OLD.id;
    END IF;
    NEW.row_version := OLD.row_version + 1;
    RETURN NEW;
END $$;

CREATE TRIGGER trg_analysis_before_update
BEFORE UPDATE ON public.analysis_result
FOR EACH ROW EXECUTE FUNCTION public.fn_analysis_result_inc_rowver();

-- video_review_platform 多平台视频审核主表
CREATE TABLE public.video_review_platform (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    video_id uuid NOT NULL REFERENCES public.video_meta(id) ON DELETE RESTRICT,
    platform public.review_platform NOT NULL,
    version_tag varchar(64) NOT NULL,
    md  text,
    filepath text,
    ppt_source_content bytea;

-- video_review_platform_history 审核变更审计历史
    
    result public.video_review_result NOT NULL DEFAULT 'pending',
    submit_time timestamptz NOT NULL DEFAULT now(),
    status_updated_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    row_version bigint NOT NULL DEFAULT 1,

    CONSTRAINT uk_review_video_platform_version UNIQUE (video_id, platform, version_tag),
    CONSTRAINT ck_vrp_version_tag_not_empty CHECK (length(trim(version_tag)) > 0),
    CONSTRAINT ck_vrp_rowver_positive CHECK (row_version > 0)
);
    ALTER TABLE public.video_review_platform
    ADD COLUMN if not EXISTS ppt_source_content bytea;

-- video_review_platform_history 审核变更审计历史表
CREATE TABLE public.video_review_platform_history (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    review_id bigint NOT NULL,
    old_md  text,
    new_md  text,
    old_result public.video_review_result,
    new_result public.video_review_result,
    old_status_updated_at timestamptz,
    new_status_updated_at timestamptz,
    old_updated_at timestamptz,
    new_updated_at timestamptz,
    old_row_version bigint,
    new_row_version bigint,
    change_at timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT fk_history_review FOREIGN KEY(review_id) REFERENCES public.video_review_platform(id) ON DELETE RESTRICT
);

CREATE INDEX idx_vrp_history_review_id ON public.video_review_platform_history(review_id);

CREATE OR REPLACE FUNCTION public.fn_vrp_enforce_fields()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    NEW.submit_time := OLD.submit_time;
    NEW.updated_at := now();
    IF OLD.result <> NEW.result THEN
        NEW.status_updated_at := now();
    END IF;
    IF OLD.row_version = 9223372036854775807 THEN
        RAISE EXCEPTION 'video_review_platform row_version overflow, id=%', OLD.id;
    END IF;
    NEW.row_version := OLD.row_version + 1;
    RETURN NEW;
END $$;

CREATE TRIGGER trg_vrp_before_update
BEFORE UPDATE ON public.video_review_platform
FOR EACH ROW EXECUTE FUNCTION public.fn_vrp_enforce_fields();

CREATE OR REPLACE FUNCTION public.fn_capture_vrp_audit_history()
RETURNS trigger LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $$
BEGIN
    INSERT INTO public.video_review_platform_history(
        review_id,
        old_md, new_md,
        old_result, new_result,
        old_status_updated_at, new_status_updated_at,
        old_updated_at, new_updated_at,
        old_row_version, new_row_version
    ) VALUES (
        OLD.id,
        OLD.md, NEW.md,
        OLD.result, NEW.result,
        OLD.status_updated_at, NEW.status_updated_at,
        OLD.updated_at, NEW.updated_at,
        OLD.row_version, NEW.row_version
    );
    RETURN NULL;
END $$;

CREATE TRIGGER trg_vrp_after_update_audit
AFTER UPDATE ON public.video_review_platform
FOR EACH ROW EXECUTE FUNCTION public.fn_capture_vrp_audit_history();

ANALYZE
    public.analysis_result,
    public.video_review_platform,
    public.video_review_platform_history;

COMMIT;


-- 事后权限加固，按需启用
-- ALTER FUNCTION public.fn_capture_vrp_audit_history() OWNER TO audit_owner;
-- GRANT INSERT ON public.video_review_platform_history TO audit_owner;


