ROLLBACK;

DROP TYPE IF EXISTS public.video_review_result;
CREATE TYPE public.video_review_result AS ENUM ('pending','reviewing','pass','reject');

DROP TYPE IF EXISTS public.review_platform;
CREATE TYPE public.review_platform AS ENUM ('bilibili','douyin','kuaishou');

-- 校验枚举值，确认有pending
SELECT enumlabel 
FROM pg_enum
JOIN pg_type ON pg_enum.enumtypid = pg_type.oid
WHERE typname = 'video_review_result';
