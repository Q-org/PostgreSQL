DROP TABLE IF EXISTS video_tasks;


CREATE TABLE video_tasks (
      "id" uuid NOT NULL DEFAULT gen_random_uuid(),
      "filepath" text COLLATE "pg_catalog"."default" GENERATED ALWAYS AS (
    (msg ->> 'filepath'::text)
    ) STORED,
      "msg" jsonb,
      "cli" text COLLATE "pg_catalog"."default" GENERATED ALWAYS AS (
    (msg ->> 'cli'::text)
    ) STORED,

      "blur_sigma" int4 GENERATED ALWAYS AS (
    ((msg ->> 'blurSigma'::text))::integer
    ) STORED,
      "blur_region" text COLLATE "pg_catalog"."default" GENERATED ALWAYS AS (
    (msg ->> 'blurRegion'::text)
    ) STORED,
      "blur_range" text COLLATE "pg_catalog"."default" GENERATED ALWAYS AS (
    (msg ->> 'blurRange'::text)
    ) STORED,
      "preview" bool GENERATED ALWAYS AS (
    ((msg ->> 'preview'::text))::boolean
    ) STORED,
      "status" varchar(30) COLLATE "pg_catalog"."default" DEFAULT 'pending'::character varying,
      "created_at" timestamptz(6) DEFAULT now(),
      PRIMARY KEY ("id"),
      UNIQUE ("id")
);

ALTER TABLE "public"."video_tasks" 
  ADD UNIQUE ("id");
  
  CREATE INDEX ON "public"."video_tasks" (
  "created_at"
);