-- establishing primary key for dimension table

drop table disclosure_test.agent_attorney_dim;
-- ****************************************************** agent attorney dimension table
create table disclosure_test.agent_attorney_dim as (
select
row_number() Over( order by agent_attorney_name, agent_attorney_firm_name,
agent_attorney_phone, agent_attorney_address_1, agent_attorney_city,
agent_attorney_state_province, agent_attorney_postal_code, agent_attorney_email) as agent_attorney_id
,agent_attorney_name,
agent_attorney_firm_name,
agent_attorney_phone,
agent_attorney_address_1,
agent_attorney_city,
agent_attorney_state_province,
agent_attorney_postal_code,
agent_attorney_email

from (
select distinct agent_attorney_name, agent_attorney_firm_name,
agent_attorney_phone, agent_attorney_address_1, agent_attorney_city,
agent_attorney_state_province, agent_attorney_postal_code, agent_attorney_email
from disclosure_test.disclosure_raw) t);


drop table disclosure_test.employee_dim;

-- ****************************************************** employee dimension table
CREATE TABLE disclosure_test.employee_dim as (
select row_number() Over( order by emp_contact_name, emp_contact_city, emp_contact_address_1) as employee_id,
emp_contact_name,
emp_contact_city,
emp_contact_address_1,
emp_contact_address_2,
emp_contact_state_province,
emp_contact_country,
emp_contact_postal_code,
emp_contact_phone,
emp_contact_email
from (
select distinct
emp_contact_name,
emp_contact_city,
emp_contact_address_1,
emp_contact_address_2,
emp_contact_state_province,
emp_contact_country,
emp_contact_postal_code,
emp_contact_phone,
emp_contact_email
from disclosure_test.disclosure_raw) t);

drop table disclosure_test.employer_dim;

-- ****************************************************** employer dimension table
CREATE TABLE disclosure_test.employer_dim as (
select row_number() Over( order by employer_name) as employer_id,
employer_name,
employer_phone,
employer_address_1,
employer_address_2,
employer_city,
employer_state_province,
employer_country,
employer_postal_code,
employer_phone_ext,
employer_year_commenced_business,
naics_code 
from (select distinct employer_name,
employer_phone,
employer_address_1,
employer_address_2,
employer_city,
employer_state_province,
employer_country,
employer_postal_code,
employer_phone_ext,
employer_year_commenced_business,
naics_code
from disclosure_test.disclosure_raw) t);



-- ****************************************************** date dimension table
CREATE TABLE disclosure_test.date_dim
(
  date_dim_id              INT NOT NULL,
  date_actual              DATE NOT NULL,
  epoch                    BIGINT NOT NULL,
  day_suffix               VARCHAR(4) NOT NULL,
  day_name                 VARCHAR(9) NOT NULL,
  day_of_week              INT NOT NULL,
  day_of_month             INT NOT NULL,
  day_of_quarter           INT NOT NULL,
  day_of_year              INT NOT NULL,
  week_of_month            INT NOT NULL,
  week_of_year             INT NOT NULL,
  week_of_year_iso         CHAR(10) NOT NULL,
  month_actual             INT NOT NULL,
  month_name               VARCHAR(9) NOT NULL,
  month_name_abbreviated   CHAR(3) NOT NULL,
  quarter_actual           INT NOT NULL,
  quarter_name             VARCHAR(9) NOT NULL,
  year_actual              INT NOT NULL,
  first_day_of_week        DATE NOT NULL,
  last_day_of_week         DATE NOT NULL,
  first_day_of_month       DATE NOT NULL,
  last_day_of_month        DATE NOT NULL,
  first_day_of_quarter     DATE NOT NULL,
  last_day_of_quarter      DATE NOT NULL,
  first_day_of_year        DATE NOT NULL,
  last_day_of_year         DATE NOT NULL,
  mmyyyy                   CHAR(6) NOT NULL,
  mmddyyyy                 CHAR(10) NOT NULL,
  weekend_indr             BOOLEAN NOT NULL
);



ALTER TABLE disclosure_test.date_dim ADD CONSTRAINT d_date_date_dim_id_pk PRIMARY KEY (date_dim_id);

CREATE INDEX d_date_date_actual_idx
  ON disclosure_test.date_dim(date_actual);

COMMIT;

INSERT INTO disclosure_test.date_dim
SELECT TO_CHAR(datum, 'yyyymmdd')::INT AS date_dim_id,
       datum AS date_actual,
       EXTRACT(EPOCH FROM datum) AS epoch,
       TO_CHAR(datum, 'fmDDth') AS day_suffix,
       TO_CHAR(datum, 'TMDay') AS day_name,
       EXTRACT(ISODOW FROM datum) AS day_of_week,
       EXTRACT(DAY FROM datum) AS day_of_month,
       datum - DATE_TRUNC('quarter', datum)::DATE + 1 AS day_of_quarter,
       EXTRACT(DOY FROM datum) AS day_of_year,
       TO_CHAR(datum, 'W')::INT AS week_of_month,
       EXTRACT(WEEK FROM datum) AS week_of_year,
       EXTRACT(ISOYEAR FROM datum) || TO_CHAR(datum, '"-W"IW-') || EXTRACT(ISODOW FROM datum) AS week_of_year_iso,
       EXTRACT(MONTH FROM datum) AS month_actual,
       TO_CHAR(datum, 'TMMonth') AS month_name,
       TO_CHAR(datum, 'Mon') AS month_name_abbreviated,
       EXTRACT(QUARTER FROM datum) AS quarter_actual,
       CASE
           WHEN EXTRACT(QUARTER FROM datum) = 1 THEN 'First'
           WHEN EXTRACT(QUARTER FROM datum) = 2 THEN 'Second'
           WHEN EXTRACT(QUARTER FROM datum) = 3 THEN 'Third'
           WHEN EXTRACT(QUARTER FROM datum) = 4 THEN 'Fourth'
           END AS quarter_name,
       EXTRACT(YEAR FROM datum) AS year_actual,
       datum + (1 - EXTRACT(ISODOW FROM datum))::INT AS first_day_of_week,
       datum + (7 - EXTRACT(ISODOW FROM datum))::INT AS last_day_of_week,
       datum + (1 - EXTRACT(DAY FROM datum))::INT AS first_day_of_month,
       (DATE_TRUNC('MONTH', datum) + INTERVAL '1 MONTH - 1 day')::DATE AS last_day_of_month,
       DATE_TRUNC('quarter', datum)::DATE AS first_day_of_quarter,
       (DATE_TRUNC('quarter', datum) + INTERVAL '3 MONTH - 1 day')::DATE AS last_day_of_quarter,
       TO_DATE(EXTRACT(YEAR FROM datum) || '-01-01', 'YYYY-MM-DD') AS first_day_of_year,
       TO_DATE(EXTRACT(YEAR FROM datum) || '-12-31', 'YYYY-MM-DD') AS last_day_of_year,
       TO_CHAR(datum, 'mmyyyy') AS mmyyyy,
       TO_CHAR(datum, 'mmddyyyy') AS mmddyyyy,
       CASE
           WHEN EXTRACT(ISODOW FROM datum) IN (6, 7) THEN TRUE
           ELSE FALSE
           END AS weekend_indr
FROM (SELECT '1970-01-01'::DATE + SEQUENCE.DAY AS datum
      FROM GENERATE_SERIES(0, 29219) AS SEQUENCE (DAY)
      GROUP BY SEQUENCE.DAY) DQ
ORDER BY 1;

COMMIT;

-- ****************************************************** Checking Dimension Tables exist
select * from disclosure_test.date_dim
select * from disclosure_test.agent_attorney_dim
select * from disclosure_test.employee_dim
select * from disclosure_test.employer_dim

-- ****************************************************** Case Fact Table
create disclosure_test.case_fact
as
select
	r.id,
	r.case_status,
	r.refile,
	r.schd_a_sheepherder,
	d.dim_date_id as received_date_id,
	d.dim_date_id as decision_date_id,
	emp.employer_id,
	e.employee_id,
	aad.agent_attorney_id
from disclosure_test.disclosure_raw r
join disclosure_test.agent_attorney_dim aad
on r.agent_attorney_name = aad.agent_attorney_name
join disclosure_test.employer_dim emp
on r.employer_name = emp.employer_name
join disclosure_test.employee_dim e
on e.emp_contact_name = r.emp_contact_name
join disclosure_test.date_dim d
on r.received_date = d.date_actual
join disclosure_test.date_dim d
on r.decision_date = d.date_actual