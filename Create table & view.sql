CREATE SCHEMA IF NOT EXISTS testrakamin;

CREATE TABLE testrakamin."dim_companies" (
  "company_id" serial PRIMARY KEY,
  "name" text UNIQUE NOT NULL
);

CREATE TABLE testrakamin."dim_areas" (
  "area_id" serial PRIMARY KEY,
  "name" text UNIQUE NOT NULL
);

CREATE TABLE testrakamin."dim_positions" (
  "position_id" serial PRIMARY KEY,
  "name" text UNIQUE NOT NULL
);

CREATE TABLE testrakamin."dim_departments" (
  "department_id" serial PRIMARY KEY,
  "name" text UNIQUE NOT NULL
);

CREATE TABLE testrakamin."dim_divisions" (
  "division_id" serial PRIMARY KEY,
  "name" text UNIQUE NOT NULL
);

CREATE TABLE testrakamin."dim_directorates" (
  "directorate_id" serial PRIMARY KEY,
  "name" text UNIQUE NOT NULL
);

CREATE TABLE testrakamin."dim_grades" (
  "grade_id" serial PRIMARY KEY,
  "name" text UNIQUE NOT NULL
);

CREATE TABLE testrakamin."dim_education" (
  "education_id" serial PRIMARY KEY,
  "name" text UNIQUE NOT NULL
);

CREATE TABLE testrakamin."dim_majors" (
  "major_id" serial PRIMARY KEY,
  "name" text UNIQUE NOT NULL
);

CREATE TABLE testrakamin."dim_competency_pillars" (
  "pillar_code" varchar(3) PRIMARY KEY,
  "pillar_label" text NOT NULL
);

CREATE TABLE testrakamin."employees" (
  "employee_id" text PRIMARY KEY,
  "fullname" text,
  "nip" text,
  "company_id" int,
  "area_id" int,
  "position_id" int,
  "department_id" int,
  "division_id" int,
  "directorate_id" int,
  "grade_id" int,
  "education_id" int,
  "major_id" int,
  "years_of_service_months" int
);

CREATE TABLE testrakamin."profiles_psych" (
  "employee_id" text PRIMARY KEY,
  "pauli" numeric,
  "faxtor" numeric,
  "disc" text,
  "disc_word" text,
  "mbti" text,
  "iq" numeric,
  "gtq" int,
  "tiki" int
);

CREATE TABLE testrakamin."papi_scores" (
  "employee_id" text,
  "scale_code" text,
  "score" int
);

CREATE TABLE testrakamin."strengths" (
  "employee_id" text,
  "rank" int,
  "theme" text
);

CREATE TABLE testrakamin."performance_yearly" (
  "employee_id" text,
  "year" int,
  "rating" int
);

CREATE TABLE testrakamin."competencies_yearly" (
  "employee_id" text,
  "pillar_code" varchar(3),
  "year" int,
  "score" int
);

CREATE UNIQUE INDEX ON testrakamin."papi_scores" ("employee_id", "scale_code");

CREATE UNIQUE INDEX ON testrakamin."strengths" ("employee_id", "rank");

CREATE UNIQUE INDEX ON testrakamin."performance_yearly" ("employee_id", "year");

CREATE INDEX ON testrakamin."performance_yearly" ("year");

CREATE UNIQUE INDEX ON testrakamin."competencies_yearly" ("employee_id", "pillar_code", "year");

CREATE INDEX ON testrakamin."competencies_yearly" ("pillar_code", "year");

COMMENT ON TABLE testrakamin."dim_competency_pillars" IS 'Codes: GDR, CEX, IDS, QDD, STO, SEA, VCU, LIE, FTC, CSI';

COMMENT ON TABLE testrakamin."strengths" IS 'CliftonStrengths rank 1..14';

ALTER TABLE testrakamin."employees" ADD FOREIGN KEY ("company_id") REFERENCES testrakamin."dim_companies" ("company_id");

ALTER TABLE testrakamin."employees" ADD FOREIGN KEY ("area_id") REFERENCES testrakamin."dim_areas" ("area_id");

ALTER TABLE testrakamin."employees" ADD FOREIGN KEY ("position_id") REFERENCES testrakamin."dim_positions" ("position_id");

ALTER TABLE testrakamin."employees" ADD FOREIGN KEY ("department_id") REFERENCES testrakamin."dim_departments" ("department_id");

ALTER TABLE testrakamin."employees" ADD FOREIGN KEY ("division_id") REFERENCES testrakamin."dim_divisions" ("division_id");

ALTER TABLE testrakamin."employees" ADD FOREIGN KEY ("directorate_id") REFERENCES testrakamin."dim_directorates" ("directorate_id");

ALTER TABLE testrakamin."employees" ADD FOREIGN KEY ("grade_id") REFERENCES testrakamin."dim_grades" ("grade_id");

ALTER TABLE testrakamin."employees" ADD FOREIGN KEY ("education_id") REFERENCES testrakamin."dim_education" ("education_id");

ALTER TABLE testrakamin."employees" ADD FOREIGN KEY ("major_id") REFERENCES testrakamin."dim_majors" ("major_id");

ALTER TABLE testrakamin."profiles_psych" ADD FOREIGN KEY ("employee_id") REFERENCES testrakamin."employees" ("employee_id");

ALTER TABLE testrakamin."papi_scores" ADD FOREIGN KEY ("employee_id") REFERENCES testrakamin."employees" ("employee_id");

ALTER TABLE testrakamin."strengths" ADD FOREIGN KEY ("employee_id") REFERENCES testrakamin."employees" ("employee_id");

ALTER TABLE testrakamin."performance_yearly" ADD FOREIGN KEY ("employee_id") REFERENCES testrakamin."employees" ("employee_id");

ALTER TABLE testrakamin."competencies_yearly" ADD FOREIGN KEY ("employee_id") REFERENCES testrakamin."employees" ("employee_id");

ALTER TABLE testrakamin."competencies_yearly" ADD FOREIGN KEY ("pillar_code") REFERENCES testrakamin."dim_competency_pillars" ("pillar_code");


CREATE ROLE naufal_tampan_rakamin_test_u
  WITH LOGIN
  PASSWORD 'm@Sn4UFalt@mPan'
  NOSUPERUSER
  NOCREATEDB
  NOCREATEROLE
  NOINHERIT;
  
ALTER ROLE naufal_tampan_rakamin_test_u SET search_path = testrakamin;
GRANT USAGE, CREATE ON SCHEMA testrakamin TO naufal_tampan_rakamin_test_u;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA testrakamin TO naufal_tampan_rakamin_test_u;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA testrakamin TO naufal_tampan_rakamin_test_u;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA testrakamin TO naufal_tampan_rakamin_test_u;


ALTER DEFAULT PRIVILEGES IN SCHEMA testrakamin
  GRANT ALL PRIVILEGES ON TABLES TO naufal_tampan_rakamin_test_u;

ALTER DEFAULT PRIVILEGES IN SCHEMA testrakamin
  GRANT ALL PRIVILEGES ON SEQUENCES TO naufal_tampan_rakamin_test_u;

ALTER DEFAULT PRIVILEGES IN SCHEMA testrakamin
  GRANT ALL PRIVILEGES ON FUNCTIONS TO naufal_tampan_rakamin_test_u;
  
CREATE OR REPLACE VIEW testrakamin.vw_employees_full AS
SELECT 
    e.employee_id,
    e.fullname,
    e.nip,
    e.years_of_service_months,

    c.name AS company_name,
    a.name AS area_name,
    p.name AS position_name,
    d.name AS department_name,
    v.name AS division_name,
    dr.name AS directorate_name,
    g.name AS grade_name,
    ed.name AS education_name,
    m.name AS major_name

FROM testrakamin.employees e
LEFT JOIN testrakamin.dim_companies c ON e.company_id = c.company_id
LEFT JOIN testrakamin.dim_areas a ON e.area_id = a.area_id
LEFT JOIN testrakamin.dim_positions p ON e.position_id = p.position_id
LEFT JOIN testrakamin.dim_departments d ON e.department_id = d.department_id
LEFT JOIN testrakamin.dim_divisions v ON e.division_id = v.division_id
LEFT JOIN testrakamin.dim_directorates dr ON e.directorate_id = dr.directorate_id
LEFT JOIN testrakamin.dim_grades g ON e.grade_id = g.grade_id
LEFT JOIN testrakamin.dim_education ed ON e.education_id = ed.education_id
LEFT JOIN testrakamin.dim_majors m ON e.major_id = m.major_id;

select count(*) from testrakamin.employees e;


CREATE OR REPLACE VIEW testrakamin.vw_competencies_pivot AS
SELECT 
    e.employee_id,
    c.year,
    COALESCE(MAX(CASE WHEN c.pillar_code = 'CEX' THEN c.score END), 0) AS cex,
    COALESCE(MAX(CASE WHEN c.pillar_code = 'CSI' THEN c.score END), 0) AS csi,
    COALESCE(MAX(CASE WHEN c.pillar_code = 'FTC' THEN c.score END), 0) AS ftc,
    COALESCE(MAX(CASE WHEN c.pillar_code = 'GDR' THEN c.score END), 0) AS gdr,
    COALESCE(MAX(CASE WHEN c.pillar_code = 'IDS' THEN c.score END), 0) AS ids,
    COALESCE(MAX(CASE WHEN c.pillar_code = 'LIE' THEN c.score END), 0) AS lie,
    COALESCE(MAX(CASE WHEN c.pillar_code = 'QDD' THEN c.score END), 0) AS qdd,
    COALESCE(MAX(CASE WHEN c.pillar_code = 'SEA' THEN c.score END), 0) AS sea,
    COALESCE(MAX(CASE WHEN c.pillar_code = 'STO' THEN c.score END), 0) AS sto,
    COALESCE(MAX(CASE WHEN c.pillar_code = 'VCU' THEN c.score END), 0) AS vcu
FROM 
    testrakamin.employees e
LEFT JOIN 
    testrakamin.competencies_yearly c 
    ON e.employee_id = c.employee_id
GROUP BY 
    e.employee_id, c.year
ORDER BY 
    e.employee_id, c.year;
   
select count(*) from testrakamin.vw_competencies_pivot;

CREATE OR REPLACE VIEW testrakamin.vw_employees_competencies AS
SELECT
    e.employee_id,
    e.fullname,
    e.nip,
    e.company_id,
    e.area_id,
    e.position_id,
    e.department_id,
    e.division_id,
    e.directorate_id,
    e.grade_id,
    e.education_id,
    e.major_id,
    e.years_of_service_months,
    cy.year,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'CEX' THEN cy.score END), 0) AS cex,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'CSI' THEN cy.score END), 0) AS csi,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'FTC' THEN cy.score END), 0) AS ftc,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'GDR' THEN cy.score END), 0) AS gdr,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'IDS' THEN cy.score END), 0) AS ids,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'LIE' THEN cy.score END), 0) AS lie,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'QDD' THEN cy.score END), 0) AS qdd,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'SEA' THEN cy.score END), 0) AS sea,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'STO' THEN cy.score END), 0) AS sto,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'VCU' THEN cy.score END), 0) AS vcu
FROM
    testrakamin.employees e
LEFT JOIN
    testrakamin.competencies_yearly cy
    ON e.employee_id = cy.employee_id
GROUP BY
    e.employee_id,
    e.fullname,
    e.nip,
    e.company_id,
    e.area_id,
    e.position_id,
    e.department_id,
    e.division_id,
    e.directorate_id,
    e.grade_id,
    e.education_id,
    e.major_id,
    e.years_of_service_months,
    cy.year
ORDER BY
    e.employee_id, cy.year;

select count(*) from testrakamin.vw_employees_competencies;

select count(position_name) from testrakamin.vw_employees_competencies_usfrndl;

CREATE OR REPLACE VIEW testrakamin.vw_employees_competencies_usfrndl AS
SELECT
    e.employee_id,
    e.fullname,
    e.nip,
    e.years_of_service_months,

    c.name  AS company_name,
    a.name  AS area_name,
    p.name  AS position_name,
    d.name  AS department_name,
    v.name  AS division_name,
    dr.name AS directorate_name,
    g.name  AS grade_name,
    ed.name AS education_name,
    m.name  AS major_name,

    cy.year,

    COALESCE(MAX(CASE WHEN cy.pillar_code = 'CEX' THEN cy.score END), 0) AS cex,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'CSI' THEN cy.score END), 0) AS csi,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'FTC' THEN cy.score END), 0) AS ftc,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'GDR' THEN cy.score END), 0) AS gdr,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'IDS' THEN cy.score END), 0) AS ids,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'LIE' THEN cy.score END), 0) AS lie,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'QDD' THEN cy.score END), 0) AS qdd,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'SEA' THEN cy.score END), 0) AS sea,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'STO' THEN cy.score END), 0) AS sto,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'VCU' THEN cy.score END), 0) AS vcu

FROM testrakamin.employees e
LEFT JOIN testrakamin.dim_companies c       ON e.company_id     = c.company_id
LEFT JOIN testrakamin.dim_areas a           ON e.area_id        = a.area_id
LEFT JOIN testrakamin.dim_positions p       ON e.position_id    = p.position_id
LEFT JOIN testrakamin.dim_departments d     ON e.department_id  = d.department_id
LEFT JOIN testrakamin.dim_divisions v       ON e.division_id    = v.division_id
LEFT JOIN testrakamin.dim_directorates dr   ON e.directorate_id = dr.directorate_id
LEFT JOIN testrakamin.dim_grades g          ON e.grade_id       = g.grade_id
LEFT JOIN testrakamin.dim_education ed      ON e.education_id   = ed.education_id
LEFT JOIN testrakamin.dim_majors m          ON e.major_id       = m.major_id
LEFT JOIN testrakamin.competencies_yearly cy ON e.employee_id   = cy.employee_id

GROUP BY
    e.employee_id,
    e.fullname,
    e.nip,
    e.years_of_service_months,
    c.name, a.name, p.name, d.name, v.name, dr.name,
    g.name, ed.name, m.name,
    cy.year
ORDER BY
    e.employee_id, cy.year;
   
select count(*) from testrakamin.vw_employees_competencies_usfrndl;

select count(*) from testrakamin.profiles_psych pp;
select count(*) from testrakamin.strengths; -- 14 Data
select count(*) from testrakamin.papi_scores; -- 20 data
select count(*) from testrakamin.employees e ;

CREATE OR REPLACE VIEW testrakamin.vw_employees_performa AS
SELECT
    e.employee_id,
    e.fullname,
    e.nip,
    e.years_of_service_months,
    e.company_id,
    e.area_id,
    e.position_id,
    e.department_id,
    e.division_id,
    e.directorate_id,
    e.grade_id,
    e.education_id,
    e.major_id,
    cy.year,

    COALESCE(MAX(CASE WHEN cy.pillar_code = 'CEX' THEN cy.score END), 0) AS cex,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'CSI' THEN cy.score END), 0) AS csi,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'FTC' THEN cy.score END), 0) AS ftc,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'GDR' THEN cy.score END), 0) AS gdr,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'IDS' THEN cy.score END), 0) AS ids,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'LIE' THEN cy.score END), 0) AS lie,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'QDD' THEN cy.score END), 0) AS qdd,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'SEA' THEN cy.score END), 0) AS sea,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'STO' THEN cy.score END), 0) AS sto,
    COALESCE(MAX(CASE WHEN cy.pillar_code = 'VCU' THEN cy.score END), 0) AS vcu,

    COALESCE(py.rating, 0) AS rating

FROM
    testrakamin.employees e
LEFT JOIN
    testrakamin.competencies_yearly cy
    ON e.employee_id = cy.employee_id
LEFT JOIN
    testrakamin.performance_yearly py
    ON e.employee_id = py.employee_id
    AND cy.year = py.year

GROUP BY
    e.employee_id,
    e.fullname,
    e.nip,
    e.company_id,
    e.area_id,
    e.position_id,
    e.department_id,
    e.division_id,
    e.directorate_id,
    e.grade_id,
    e.education_id,
    e.major_id,
    e.years_of_service_months,
    cy.year,
    py.rating

ORDER BY
    e.employee_id,
    cy.year;
    
select count(*) from vw_employees_performa;

CREATE OR REPLACE VIEW testrakamin.vw_employees_psikologi AS
WITH papi_pivot AS (
    SELECT
        employee_id,
        COALESCE(MAX(CASE WHEN scale_code = 'Papi_N' THEN score END), 0) AS papi_n,
        COALESCE(MAX(CASE WHEN scale_code = 'Papi_G' THEN score END), 0) AS papi_g,
        COALESCE(MAX(CASE WHEN scale_code = 'Papi_A' THEN score END), 0) AS papi_a,
        COALESCE(MAX(CASE WHEN scale_code = 'Papi_L' THEN score END), 0) AS papi_l,
        COALESCE(MAX(CASE WHEN scale_code = 'Papi_P' THEN score END), 0) AS papi_p,
        COALESCE(MAX(CASE WHEN scale_code = 'Papi_I' THEN score END), 0) AS papi_i,
        COALESCE(MAX(CASE WHEN scale_code = 'Papi_T' THEN score END), 0) AS papi_t,
        COALESCE(MAX(CASE WHEN scale_code = 'Papi_V' THEN score END), 0) AS papi_v,
        COALESCE(MAX(CASE WHEN scale_code = 'Papi_O' THEN score END), 0) AS papi_o,
        COALESCE(MAX(CASE WHEN scale_code = 'Papi_B' THEN score END), 0) AS papi_b,
        COALESCE(MAX(CASE WHEN scale_code = 'Papi_S' THEN score END), 0) AS papi_s,
        COALESCE(MAX(CASE WHEN scale_code = 'Papi_X' THEN score END), 0) AS papi_x,
        COALESCE(MAX(CASE WHEN scale_code = 'Papi_C' THEN score END), 0) AS papi_c,
        COALESCE(MAX(CASE WHEN scale_code = 'Papi_D' THEN score END), 0) AS papi_d,
        COALESCE(MAX(CASE WHEN scale_code = 'Papi_R' THEN score END), 0) AS papi_r,
        COALESCE(MAX(CASE WHEN scale_code = 'Papi_Z' THEN score END), 0) AS papi_z,
        COALESCE(MAX(CASE WHEN scale_code = 'Papi_E' THEN score END), 0) AS papi_e,
        COALESCE(MAX(CASE WHEN scale_code = 'Papi_K' THEN score END), 0) AS papi_k,
        COALESCE(MAX(CASE WHEN scale_code = 'Papi_F' THEN score END), 0) AS papi_f,
        COALESCE(MAX(CASE WHEN scale_code = 'Papi_W' THEN score END), 0) AS papi_w
    FROM testrakamin.papi_scores
    GROUP BY employee_id
),
strengths_pivot AS (
    SELECT
        employee_id,
        COALESCE(MAX(CASE WHEN theme = 'Achiever' THEN rank END), 0) AS achiever,
        COALESCE(MAX(CASE WHEN theme = 'Arranger' THEN rank END), 0) AS arranger,
        COALESCE(MAX(CASE WHEN theme = 'Belief' THEN rank END), 0) AS belief,
        COALESCE(MAX(CASE WHEN theme = 'Consistency' THEN rank END), 0) AS consistency,
        COALESCE(MAX(CASE WHEN theme = 'Deliberative' THEN rank END), 0) AS deliberative,
        COALESCE(MAX(CASE WHEN theme = 'Discipline' THEN rank END), 0) AS discipline,
        COALESCE(MAX(CASE WHEN theme = 'Focus' THEN rank END), 0) AS focus,
        COALESCE(MAX(CASE WHEN theme = 'Responsibility' THEN rank END), 0) AS responsibility,
        COALESCE(MAX(CASE WHEN theme = 'Restorative' THEN rank END), 0) AS restorative,
        COALESCE(MAX(CASE WHEN theme = 'Activator' THEN rank END), 0) AS activator,
        COALESCE(MAX(CASE WHEN theme = 'Command' THEN rank END), 0) AS command,
        COALESCE(MAX(CASE WHEN theme = 'Communication' THEN rank END), 0) AS communication,
        COALESCE(MAX(CASE WHEN theme = 'Competition' THEN rank END), 0) AS competition,
        COALESCE(MAX(CASE WHEN theme = 'Maximizer' THEN rank END), 0) AS maximizer,
        COALESCE(MAX(CASE WHEN theme = 'Self-Assurance' THEN rank END), 0) AS self_assurance,
        COALESCE(MAX(CASE WHEN theme = 'Significance' THEN rank END), 0) AS significance,
        COALESCE(MAX(CASE WHEN theme = 'Woo (Winning Others Over)' THEN rank END), 0) AS woo,
        COALESCE(MAX(CASE WHEN theme = 'Adaptability' THEN rank END), 0) AS adaptability,
        COALESCE(MAX(CASE WHEN theme = 'Connectedness' THEN rank END), 0) AS connectedness,
        COALESCE(MAX(CASE WHEN theme = 'Developer' THEN rank END), 0) AS developer,
        COALESCE(MAX(CASE WHEN theme = 'Empathy' THEN rank END), 0) AS empathy,
        COALESCE(MAX(CASE WHEN theme = 'Harmony' THEN rank END), 0) AS harmony,
        COALESCE(MAX(CASE WHEN theme = 'Includer' THEN rank END), 0) AS includer,
        COALESCE(MAX(CASE WHEN theme = 'Individualization' THEN rank END), 0) AS individualization,
        COALESCE(MAX(CASE WHEN theme = 'Positivity' THEN rank END), 0) AS positivity,
        COALESCE(MAX(CASE WHEN theme = 'Relator' THEN rank END), 0) AS relator,
        COALESCE(MAX(CASE WHEN theme = 'Analytical' THEN rank END), 0) AS analytical,
        COALESCE(MAX(CASE WHEN theme = 'Context' THEN rank END), 0) AS context,
        COALESCE(MAX(CASE WHEN theme = 'Futuristic' THEN rank END), 0) AS futuristic,
        COALESCE(MAX(CASE WHEN theme = 'Ideation' THEN rank END), 0) AS ideation,
        COALESCE(MAX(CASE WHEN theme = 'Input' THEN rank END), 0) AS input,
        COALESCE(MAX(CASE WHEN theme = 'Intellection' THEN rank END), 0) AS intellection,
        COALESCE(MAX(CASE WHEN theme = 'Learner' THEN rank END), 0) AS learner,
        COALESCE(MAX(CASE WHEN theme = 'Strategic' THEN rank END), 0) AS strategic
    FROM testrakamin.strengths
    GROUP BY employee_id
)
SELECT
    e.employee_id,
    e.fullname,
    e.nip,
    e.company_id,
    e.area_id,
    e.position_id,
    e.department_id,
    e.division_id,
    e.directorate_id,
    e.grade_id,
    e.education_id,
    e.major_id,
    e.years_of_service_months,

    ps.pauli,
    ps.faxtor,
    ps.disc,
    ps.disc_word,
    ps.mbti,
    ps.iq,
    ps.gtq,
    ps.tiki,

    p.papi_n, p.papi_g, p.papi_a, p.papi_l, p.papi_p, p.papi_i, p.papi_t,
    p.papi_v, p.papi_o, p.papi_b, p.papi_s, p.papi_x, p.papi_c, p.papi_d,
    p.papi_r, p.papi_z, p.papi_e, p.papi_k, p.papi_f, p.papi_w,

    s.achiever, s.arranger, s.belief, s.consistency, s.deliberative,
    s.discipline, s.focus, s.responsibility, s.restorative, s.activator,
    s.command, s.communication, s.competition, s.maximizer, s.self_assurance,
    s.significance, s.woo, s.adaptability, s.connectedness, s.developer,
    s.empathy, s.harmony, s.includer, s.individualization, s.positivity,
    s.relator, s.analytical, s.context, s.futuristic, s.ideation, s.input,
    s.intellection, s.learner, s.strategic

FROM testrakamin.employees e
LEFT JOIN testrakamin.profiles_psych ps ON e.employee_id = ps.employee_id
LEFT JOIN papi_pivot p ON e.employee_id = p.employee_id
LEFT JOIN strengths_pivot s ON e.employee_id = s.employee_id
ORDER BY e.employee_id;

CREATE OR REPLACE VIEW testrakamin.vw_employees_full_profile_with_null AS
WITH papi_pivot AS (
    SELECT
        employee_id,
        MAX(CASE WHEN scale_code = 'Papi_N' THEN score END) AS papi_n,
        MAX(CASE WHEN scale_code = 'Papi_G' THEN score END) AS papi_g,
        MAX(CASE WHEN scale_code = 'Papi_A' THEN score END) AS papi_a,
        MAX(CASE WHEN scale_code = 'Papi_L' THEN score END) AS papi_l,
        MAX(CASE WHEN scale_code = 'Papi_P' THEN score END) AS papi_p,
        MAX(CASE WHEN scale_code = 'Papi_I' THEN score END) AS papi_i,
        MAX(CASE WHEN scale_code = 'Papi_T' THEN score END) AS papi_t,
        MAX(CASE WHEN scale_code = 'Papi_V' THEN score END) AS papi_v,
        MAX(CASE WHEN scale_code = 'Papi_O' THEN score END) AS papi_o,
        MAX(CASE WHEN scale_code = 'Papi_B' THEN score END) AS papi_b,
        MAX(CASE WHEN scale_code = 'Papi_S' THEN score END) AS papi_s,
        MAX(CASE WHEN scale_code = 'Papi_X' THEN score END) AS papi_x,
        MAX(CASE WHEN scale_code = 'Papi_C' THEN score END) AS papi_c,
        MAX(CASE WHEN scale_code = 'Papi_D' THEN score END) AS papi_d,
        MAX(CASE WHEN scale_code = 'Papi_R' THEN score END) AS papi_r,
        MAX(CASE WHEN scale_code = 'Papi_Z' THEN score END) AS papi_z,
        MAX(CASE WHEN scale_code = 'Papi_E' THEN score END) AS papi_e,
        MAX(CASE WHEN scale_code = 'Papi_K' THEN score END) AS papi_k,
        MAX(CASE WHEN scale_code = 'Papi_F' THEN score END) AS papi_f,
        MAX(CASE WHEN scale_code = 'Papi_W' THEN score END) AS papi_w
    FROM testrakamin.papi_scores
    GROUP BY employee_id
),
strengths_pivot AS (
    SELECT
        employee_id,
        MAX(CASE WHEN theme = 'Achiever' THEN rank END) AS achiever,
        MAX(CASE WHEN theme = 'Arranger' THEN rank END) AS arranger,
        MAX(CASE WHEN theme = 'Belief' THEN rank END) AS belief,
        MAX(CASE WHEN theme = 'Consistency' THEN rank END) AS consistency,
        MAX(CASE WHEN theme = 'Deliberative' THEN rank END) AS deliberative,
        MAX(CASE WHEN theme = 'Discipline' THEN rank END) AS discipline,
        MAX(CASE WHEN theme = 'Focus' THEN rank END) AS focus,
        MAX(CASE WHEN theme = 'Responsibility' THEN rank END) AS responsibility,
        MAX(CASE WHEN theme = 'Restorative' THEN rank END) AS restorative,
        MAX(CASE WHEN theme = 'Activator' THEN rank END) AS activator,
        MAX(CASE WHEN theme = 'Command' THEN rank END) AS command,
        MAX(CASE WHEN theme = 'Communication' THEN rank END) AS communication,
        MAX(CASE WHEN theme = 'Competition' THEN rank END) AS competition,
        MAX(CASE WHEN theme = 'Maximizer' THEN rank END) AS maximizer,
        MAX(CASE WHEN theme = 'Self-Assurance' THEN rank END) AS self_assurance,
        MAX(CASE WHEN theme = 'Significance' THEN rank END) AS significance,
        MAX(CASE WHEN theme = 'Woo (Winning Others Over)' THEN rank END) AS woo,
        MAX(CASE WHEN theme = 'Adaptability' THEN rank END) AS adaptability,
        MAX(CASE WHEN theme = 'Connectedness' THEN rank END) AS connectedness,
        MAX(CASE WHEN theme = 'Developer' THEN rank END) AS developer,
        MAX(CASE WHEN theme = 'Empathy' THEN rank END) AS empathy,
        MAX(CASE WHEN theme = 'Harmony' THEN rank END) AS harmony,
        MAX(CASE WHEN theme = 'Includer' THEN rank END) AS includer,
        MAX(CASE WHEN theme = 'Individualization' THEN rank END) AS individualization,
        MAX(CASE WHEN theme = 'Positivity' THEN rank END) AS positivity,
        MAX(CASE WHEN theme = 'Relator' THEN rank END) AS relator,
        MAX(CASE WHEN theme = 'Analytical' THEN rank END) AS analytical,
        MAX(CASE WHEN theme = 'Context' THEN rank END) AS context,
        MAX(CASE WHEN theme = 'Futuristic' THEN rank END) AS futuristic,
        MAX(CASE WHEN theme = 'Ideation' THEN rank END) AS ideation,
        MAX(CASE WHEN theme = 'Input' THEN rank END) AS input,
        MAX(CASE WHEN theme = 'Intellection' THEN rank END) AS intellection,
        MAX(CASE WHEN theme = 'Learner' THEN rank END) AS learner,
        MAX(CASE WHEN theme = 'Strategic' THEN rank END) AS strategic
    FROM testrakamin.strengths
    GROUP BY employee_id
)
SELECT
    e.employee_id,
    e.fullname,
    e.nip,
    e.company_id,
    e.area_id,
    e.position_id,
    e.department_id,
    e.division_id,
    e.directorate_id,
    e.grade_id,
    e.education_id,
    e.major_id,
    e.years_of_service_months,

    ps.pauli,
    ps.faxtor,
    ps.disc,
    ps.disc_word,
    ps.mbti,
    ps.iq,
    ps.gtq,
    ps.tiki,

    p.papi_n, p.papi_g, p.papi_a, p.papi_l, p.papi_p, p.papi_i, p.papi_t,
    p.papi_v, p.papi_o, p.papi_b, p.papi_s, p.papi_x, p.papi_c, p.papi_d,
    p.papi_r, p.papi_z, p.papi_e, p.papi_k, p.papi_f, p.papi_w,

    s.achiever, s.arranger, s.belief, s.consistency, s.deliberative,
    s.discipline, s.focus, s.responsibility, s.restorative, s.activator,
    s.command, s.communication, s.competition, s.maximizer, s.self_assurance,
    s.significance, s.woo, s.adaptability, s.connectedness, s.developer,
    s.empathy, s.harmony, s.includer, s.individualization, s.positivity,
    s.relator, s.analytical, s.context, s.futuristic, s.ideation, s.input,
    s.intellection, s.learner, s.strategic

FROM testrakamin.employees e
LEFT JOIN testrakamin.profiles_psych ps ON e.employee_id = ps.employee_id
LEFT JOIN papi_pivot p ON e.employee_id = p.employee_id
LEFT JOIN strengths_pivot s ON e.employee_id = s.employee_id
ORDER BY e.employee_id;

CREATE TABLE testrakamin.tgv_mapping (
    tv_name text,
    tgv_name text
);

select * from testrakamin.vw_employees_psikologi vep where disc = 'None';

select rating from testrakamin.psi_perform_karyawan_imputed where employee_id = 'EMP100372';