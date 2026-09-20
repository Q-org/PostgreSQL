ALTER TABLE public.video_frames
ADD COLUMN has_image boolean,
ADD COLUMN review_status text,
ADD COLUMN review_comment text,
ADD COLUMN img_url text,
ADD COLUMN risk_ids uuid[];

COMMENT ON COLUMN public.video_frames.has_png IS '是否存在PNG截图';
COMMENT ON COLUMN public.video_frames.review_status IS '审核状态';
COMMENT ON COLUMN public.video_frames.review_comment IS '审核备注';
COMMENT ON COLUMN public.video_frames.img_url IS '图片存储地址';
COMMENT ON COLUMN public.video_frames.risk_ids IS '人工评审风险ID数组，关联review_risk.id，支持多标签，无风险为null';



DROP TABLE IF EXISTS public.review_risk;
CREATE TABLE public.review_risk (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    risk_code text NOT NULL UNIQUE,
    risk_name text NOT NULL,
    risk_level int NOT NULL, -- 风险严重等级：1最高，2，3
    description text,
    is_active boolean NOT NULL DEFAULT true,
    create_at timestamptz(6) NOT NULL DEFAULT now(),
    PRIMARY KEY (id)
);
COMMENT ON TABLE public.review_risk IS '评审风险字典库';
COMMENT ON COLUMN public.review_risk.risk_code IS '风险编码(英文，用于程序判断)';
COMMENT ON COLUMN public.review_risk.risk_name IS '风险中文名称：低俗、露点等';
COMMENT ON COLUMN public.review_risk.risk_level IS '严重等级 1=严重 2=中等 3=轻微';
COMMENT ON COLUMN public.review_risk.is_active IS '是否启用';

-- 预置基础风险数据
INSERT INTO public.review_risk(risk_code, risk_name, risk_level, description)
VALUES
('vulgar','低俗',2,'低俗画面、不雅动作'),
('nudity','露点',1,'裸露、露点画面'),
('bad_tendency','不良倾向',2,'不良价值观、不良导向'),
('violence','暴力',1,'血腥暴力画面'),
('politics','涉政',1,'涉政违规内容'),
('ad_watermark','广告水印',3,'广告、营销水印');


ALTER TABLE public.video_frames ADD COLUMN risk_ids uuid[];
COMMENT ON COLUMN public.video_frames.risk_ids IS '人工评审风险ID数组，关联review_risk.id，支持多标签';