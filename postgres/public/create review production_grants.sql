BEGIN;
-- 业务应用账号 wei
REVOKE ALL ON SCHEMA public FROM wei;
GRANT USAGE ON SCHEMA public TO wei;

-- analysis_result
GRANT SELECT,INSERT,DELETE ON public.analysis_result TO wei;
REVOKE UPDATE ON public.analysis_result FROM wei;
GRANT USAGE, SELECT ON SEQUENCE public.analysis_result_id_seq TO wei;

-- video_review_platform
GRANT SELECT,INSERT,UPDATE ON public.video_review_platform TO wei;
GRANT USAGE, SELECT ON SEQUENCE public.video_review_platform_id_seq TO wei;

-- audit history table: ONLY SELECT for application
GRANT SELECT ON public.video_review_platform_history TO wei;
REVOKE INSERT,UPDATE,DELETE,TRUNCATE ON public.video_review_platform_history FROM wei;

-- forbid application directly invoke security‑definer audit function
REVOKE EXECUTE ON FUNCTION public.capture_vrp_audit_history() FROM wei;

-- function owner must hold INSERT on audit table (adjust owner name for your env)
-- ALTER FUNCTION public.capture_vrp_audit_history() OWNER TO db_owner;
-- GRANT INSERT ON public.video_review_platform_history TO db_owner;

COMMIT;
