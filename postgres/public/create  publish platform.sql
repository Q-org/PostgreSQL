-- ============================================================
-- 0. 扩展（PG 13 以下需要）
-- ============================================================
CREATE EXTENSION IF NOT EXISTS pgcrypto;


-- ============================================================
-- 1. 平台字典表 video_platform
-- ============================================================
DROP TABLE IF EXISTS video_platform CASCADE;

CREATE TABLE video_platform (
    id          BIGSERIAL PRIMARY KEY,
    code        VARCHAR(50)  NOT NULL,      -- 平台标识: douyin/bilibili/youtube
    name        VARCHAR(100) NOT NULL,      -- 平台名称: 抖音/B站/YouTube
    icon_url    VARCHAR(500),               -- 平台图标
    home_url    VARCHAR(500),               -- 平台主页
    sort        INT          NOT NULL DEFAULT 0,
    enabled     BOOLEAN      NOT NULL DEFAULT TRUE,
    remark      VARCHAR(500),
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uk_platform_code UNIQUE (code)
);

COMMENT ON TABLE  video_platform            IS '视频平台字典表';
COMMENT ON COLUMN video_platform.id         IS '平台ID';
COMMENT ON COLUMN video_platform.code       IS '平台标识: douyin/bilibili/youtube/...';
COMMENT ON COLUMN video_platform.name       IS '平台名称: 抖音/B站/YouTube';
COMMENT ON COLUMN video_platform.icon_url   IS '平台图标';
COMMENT ON COLUMN video_platform.home_url   IS '平台主页';
COMMENT ON COLUMN video_platform.sort       IS '排序';
COMMENT ON COLUMN video_platform.enabled    IS '是否启用';
COMMENT ON COLUMN video_platform.remark     IS '备注';
COMMENT ON COLUMN video_platform.created_at IS '创建时间';
COMMENT ON COLUMN video_platform.updated_at IS '更新时间';

CREATE INDEX idx_platform_enabled_sort ON video_platform (enabled, sort);


-- ============================================================
-- 2. 平台初始化数据
-- ============================================================
INSERT INTO video_platform (code, name, sort) VALUES
    ('douyin',          '抖音',       1),
    ('kuaishou',        '快手',       2),
    ('bilibili',        'B站',        3),
    ('youtube',         'YouTube',    4),
    ('wechat_channels', '微信视频号', 5),
    ('xiaohongshu',     '小红书',     6),
    ('weibo',           '微博',       7),
    ('toutiao',         '今日头条',   8),
    ('local',           '本站',       9)
ON CONFLICT (code) DO NOTHING;


-- ============================================================
-- 3. 发布信息表 video_publish_info
--    video_id    → video_meta(id)      (父表已存在)
--    platform_id → video_platform(id)
--    user_id     允许为空, 默认 NULL
-- ============================================================
DROP TABLE IF EXISTS video_publish_info CASCADE;

CREATE TABLE video_publish_info (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    video_id              UUID   NOT NULL,               -- 关联 video_meta.id
    user_id               BIGINT DEFAULT NULL,           -- 发布者(允许为空)

    -- 平台相关
    platform_id           BIGINT NOT NULL,               -- 关联 video_platform.id
    platform_video_id     VARCHAR(255),                  -- 平台返回的视频ID
    platform_url          VARCHAR(500),                  -- 平台播放页地址
    platform_publish_time TIMESTAMPTZ,                   -- 平台侧发布时间

    title                 VARCHAR(255) NOT NULL,
    description           TEXT,
    cover_url             VARCHAR(500),
    category_id           BIGINT,
    tags                  VARCHAR(500),
    visibility            SMALLINT NOT NULL DEFAULT 1,   -- 1公开 2私密 3好友 4付费
    status                SMALLINT NOT NULL DEFAULT 0,   -- 0草稿 1待审核 2已发布 3驳回 4下架
    audit_reason          VARCHAR(500),
    publish_time          TIMESTAMPTZ,
    scheduled_time        TIMESTAMPTZ,
    view_count            BIGINT NOT NULL DEFAULT 0,
    like_count            BIGINT NOT NULL DEFAULT 0,
    comment_count         BIGINT NOT NULL DEFAULT 0,
    favorite_count        BIGINT NOT NULL DEFAULT 0,
    share_count           BIGINT NOT NULL DEFAULT 0,
    allow_comment         BOOLEAN NOT NULL DEFAULT TRUE,
    allow_download        BOOLEAN NOT NULL DEFAULT TRUE,
    is_top                BOOLEAN NOT NULL DEFAULT FALSE,
    is_recommend          BOOLEAN NOT NULL DEFAULT FALSE,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at            TIMESTAMPTZ,

    -- 外键：引用 video_meta(id)
    CONSTRAINT fk_publish_video
        FOREIGN KEY (video_id) REFERENCES video_meta(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    -- 外键：引用 video_platform(id)
    CONSTRAINT fk_publish_platform
        FOREIGN KEY (platform_id) REFERENCES video_platform(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    -- 同一平台下，平台视频ID不能重复
    CONSTRAINT uk_platform_video
        UNIQUE (platform_id, platform_video_id)
);


-- ============================================================
-- 4. 注释
-- ============================================================
COMMENT ON TABLE  video_publish_info                       IS '视频发布信息表';
COMMENT ON COLUMN video_publish_info.id                    IS '发布记录ID';
COMMENT ON COLUMN video_publish_info.video_id              IS '视频ID, 关联 video_meta.id';
COMMENT ON COLUMN video_publish_info.user_id               IS '发布者用户ID(允许为空)';
COMMENT ON COLUMN video_publish_info.platform_id           IS '平台ID, 关联 video_platform.id';
COMMENT ON COLUMN video_publish_info.platform_video_id     IS '平台返回的视频ID';
COMMENT ON COLUMN video_publish_info.platform_url          IS '平台播放页地址';
COMMENT ON COLUMN video_publish_info.platform_publish_time IS '平台侧发布时间';
COMMENT ON COLUMN video_publish_info.title                 IS '视频标题';
COMMENT ON COLUMN video_publish_info.description           IS '视频描述';
COMMENT ON COLUMN video_publish_info.cover_url             IS '本次发布封面(空则用 video_meta.cover_url)';
COMMENT ON COLUMN video_publish_info.category_id           IS '分类ID';
COMMENT ON COLUMN video_publish_info.tags                  IS '标签';
COMMENT ON COLUMN video_publish_info.visibility            IS '可见性:1公开,2私密,3好友,4付费';
COMMENT ON COLUMN video_publish_info.status                IS '状态:0草稿,1待审核,2已发布,3审核不通过,4下架';
COMMENT ON COLUMN video_publish_info.audit_reason          IS '审核原因';
COMMENT ON COLUMN video_publish_info.publish_time          IS '发布时间';
COMMENT ON COLUMN video_publish_info.scheduled_time        IS '定时发布时间';
COMMENT ON COLUMN video_publish_info.view_count            IS '播放量';
COMMENT ON COLUMN video_publish_info.like_count            IS '点赞数';
COMMENT ON COLUMN video_publish_info.comment_count         IS '评论数';
COMMENT ON COLUMN video_publish_info.favorite_count        IS '收藏数';
COMMENT ON COLUMN video_publish_info.share_count           IS '分享数';
COMMENT ON COLUMN video_publish_info.allow_comment         IS '是否允许评论';
COMMENT ON COLUMN video_publish_info.allow_download        IS '是否允许下载';
COMMENT ON COLUMN video_publish_info.is_top                IS '是否置顶';
COMMENT ON COLUMN video_publish_info.is_recommend          IS '是否推荐';
COMMENT ON COLUMN video_publish_info.created_at            IS '创建时间';
COMMENT ON COLUMN video_publish_info.updated_at            IS '更新时间';
COMMENT ON COLUMN video_publish_info.deleted_at            IS '软删除时间';


-- ============================================================
-- 5. 索引
-- ============================================================
CREATE INDEX idx_publish_video_id      ON video_publish_info (video_id);
CREATE INDEX idx_publish_user_id       ON video_publish_info (user_id);
CREATE INDEX idx_publish_platform_id   ON video_publish_info (platform_id);
CREATE INDEX idx_publish_category_id   ON video_publish_info (category_id);
CREATE INDEX idx_publish_status        ON video_publish_info (status);
CREATE INDEX idx_publish_publish_time  ON video_publish_info (publish_time);
CREATE INDEX idx_publish_created_at    ON video_publish_info (created_at);

-- 平台视频ID查询
CREATE INDEX idx_publish_platform_video_id
    ON video_publish_info (platform_video_id);

-- 按用户查已发布视频，按发布时间倒序
CREATE INDEX idx_publish_user_status_time
    ON video_publish_info (user_id, status, publish_time DESC);

-- 信息流：按状态+发布时间，排除软删除
CREATE INDEX idx_publish_status_time_alive
    ON video_publish_info (status, publish_time DESC)
    WHERE deleted_at IS NULL;

-- 按平台+状态查
CREATE INDEX idx_publish_platform_status
    ON video_publish_info (platform_id, status);


-- ============================================================
-- 6. updated_at 自动更新触发器
-- ============================================================
CREATE OR REPLACE FUNCTION trg_set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS set_updated_at_platform ON video_platform;
DROP TRIGGER IF EXISTS set_updated_at_publish  ON video_publish_info;

CREATE TRIGGER set_updated_at_platform
BEFORE UPDATE ON video_platform
FOR EACH ROW EXECUTE FUNCTION trg_set_updated_at();

CREATE TRIGGER set_updated_at_publish
BEFORE UPDATE ON video_publish_info
FOR EACH ROW EXECUTE FUNCTION trg_set_updated_at();