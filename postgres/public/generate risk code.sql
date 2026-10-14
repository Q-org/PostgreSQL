SELECT
    '请识别'

    || jsonb_agg( (f.risk_name || ' `' || f.risk_code||'`') ORDER BY f.create_at DESC )::text 
    || E'\n'
    || '格式：'
    || E'\n'
    || '#### 1. 淫秽色情 `obscene`'
    || E'\n'
    || 'Page 235、236、237：被害人被绑手脚、堵嘴、勒颈，架三脚架拍摄'
    AS risk_name,
	jsonb_agg(f.risk_code) AS risk_code
FROM
	review_risk AS f
WHERE
	f.risk_level = 2
;