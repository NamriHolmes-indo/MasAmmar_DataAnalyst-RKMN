WITH
tv_list AS (
    SELECT * FROM (VALUES
        ('iq','Cognitive'),
        ('gtq','Cognitive'),
        ('pauli','Cognitive'),
        ('faxtor','Cognitive'),
        ('sto','Competency'),
        ('cex','Competency'),
        ('gdr','Competency'),
        ('sea','Competency'),
        ('vcu','Competency'),
        ('intellection','Reflective'),
        ('maximizer','Reflective'),
        ('connectedness','Reflective')
    ) AS t(tv_name, tgv_name)
),

benchmark_pool AS (
    SELECT 
        p.employee_id,
        p.iq, p.gtq, p.pauli, p.faxtor,
        c.sto, c.cex, c.gdr, c.sea, c.vcu,
        p.intellection, p.maximizer, p.connectedness
    FROM testrakamin.psi_perform_karyawan_imputed p
    LEFT JOIN testrakamin.vw_employees_performa c 
        ON p.employee_id = c.employee_id
    WHERE c.rating = 5
      AND c.year = 2025
),

baseline AS (
    SELECT 
        t.tv_name,
        t.tgv_name,
        percentile_cont(0.5) WITHIN GROUP (ORDER BY
            CASE t.tv_name
                WHEN 'iq' THEN b.iq
                WHEN 'gtq' THEN b.gtq
                WHEN 'pauli' THEN b.pauli
                WHEN 'faxtor' THEN b.faxtor
                WHEN 'sto' THEN b.sto
                WHEN 'cex' THEN b.cex
                WHEN 'gdr' THEN b.gdr
                WHEN 'sea' THEN b.sea
                WHEN 'vcu' THEN b.vcu
                WHEN 'intellection' THEN b.intellection
                WHEN 'maximizer' THEN b.maximizer
                WHEN 'connectedness' THEN b.connectedness
            END
        ) AS baseline_score
    FROM tv_list t
    CROSS JOIN benchmark_pool b
    GROUP BY t.tv_name, t.tgv_name
),

employee_scores AS (
    SELECT 
        p.employee_id,
        p.fullname,
        p.iq, p.gtq, p.pauli, p.faxtor,
        c.sto, c.cex, c.gdr, c.sea, c.vcu,
        p.intellection, p.maximizer, p.connectedness,
        c.year,
        c.rating
    FROM testrakamin.psi_perform_karyawan_imputed p
    LEFT JOIN testrakamin.vw_employees_performa c 
        ON p.employee_id = c.employee_id
    WHERE c.year = 2025
),

tv_match AS (
    SELECT
        e.employee_id,
        e.fullname,
        t.tgv_name,
        t.tv_name,
        b.baseline_score,
        CASE t.tv_name
            WHEN 'iq' THEN e.iq
            WHEN 'gtq' THEN e.gtq
            WHEN 'pauli' THEN e.pauli
            WHEN 'faxtor' THEN e.faxtor
            WHEN 'sto' THEN e.sto
            WHEN 'cex' THEN e.cex
            WHEN 'gdr' THEN e.gdr
            WHEN 'sea' THEN e.sea
            WHEN 'vcu' THEN e.vcu
            WHEN 'intellection' THEN e.intellection
            WHEN 'maximizer' THEN e.maximizer
            WHEN 'connectedness' THEN e.connectedness
        END AS user_score,
        CASE 
            WHEN b.baseline_score IS NOT NULL AND b.baseline_score > 0 THEN 
                ROUND(
                    LEAST(
                        ((CASE t.tv_name
                            WHEN 'iq' THEN e.iq
                            WHEN 'gtq' THEN e.gtq
                            WHEN 'pauli' THEN e.pauli
                            WHEN 'faxtor' THEN e.faxtor
                            WHEN 'sto' THEN e.sto
                            WHEN 'cex' THEN e.cex
                            WHEN 'gdr' THEN e.gdr
                            WHEN 'sea' THEN e.sea
                            WHEN 'vcu' THEN e.vcu
                            WHEN 'intellection' THEN e.intellection
                            WHEN 'maximizer' THEN e.maximizer
                            WHEN 'connectedness' THEN e.connectedness
                        END / b.baseline_score) * 100),
                    150)::numeric, 2)
            ELSE NULL
        END AS tv_match_rate
    FROM employee_scores e
    CROSS JOIN tv_list t
    LEFT JOIN baseline b ON b.tv_name = t.tv_name
),

tgv_match AS (
    SELECT
        employee_id,
        tgv_name,
        ROUND(AVG(tv_match_rate)::numeric, 2) AS tgv_match_rate
    FROM tv_match
    WHERE tv_match_rate IS NOT NULL
    GROUP BY employee_id, tgv_name
),

final_match AS (
    SELECT
        employee_id,
        ROUND((
            COALESCE(0.35 * MAX(CASE WHEN tgv_name = 'Cognitive' THEN tgv_match_rate END), 0) +
            COALESCE(0.30 * MAX(CASE WHEN tgv_name = 'Competency' THEN tgv_match_rate END), 0) +
            COALESCE(0.20 * MAX(CASE WHEN tgv_name = 'Reflective' THEN tgv_match_rate END), 0)
        )::numeric, 2) AS final_match_rate
    FROM tgv_match
    GROUP BY employee_id
)

SELECT 
    e.employee_id,
    e.fullname,
    e.rating,
    e.year,
    tv.tv_name,
    tv.tgv_name,
    tv.baseline_score,
    tv.user_score,
    tv.tv_match_rate,
    tg.tgv_match_rate,
    fm.final_match_rate
FROM tv_match tv
LEFT JOIN tgv_match tg 
    ON tv.employee_id = tg.employee_id AND tv.tgv_name = tg.tgv_name
LEFT JOIN final_match fm 
    ON tv.employee_id = fm.employee_id
LEFT JOIN employee_scores e 
    ON tv.employee_id = e.employee_id
ORDER BY fm.final_match_rate DESC NULLS LAST, e.fullname;
