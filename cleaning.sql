drop table temp_testing.monthly_temp;
create table temp_testing.monthly_temp (
source text,
datetime text,
mean_temp text)

select * from disclosure_test.disclosure_raw;

-- renaming table to "raw"
alter table disclosure_test.disclosure_test_fact rename to disclosure_raw;

-- Dropping columns in table because of too many nulls
alter table disclosure_test.disclosure_raw
drop column agent_attorney_address_2,
drop column employer_phone_ext,
drop column previous_swa_case_number_state,
drop column orig_file_date;


-- establishing primary key for dimension table
select
row_number() Over( order by agent_attorney_name, agent_attorney_firm_name,
agent_attorney_phone, agent_attorney_address_1, agent_attorney_city,
agent_attorney_state_province, agent_attorney_postal_code, agent_attorney_email)
,agent_attorney_name,
agent_attorney_firm_name,
agent_attorney_phone,
agent_attorney_address_1,
agent_attorney_city,
agent_attorney_state_province,
agent_attorney_postal_code,
agent_attorney_email
as agent_attorney_id
from (
select distinct agent_attorney_name, agent_attorney_firm_name,
agent_attorney_phone, agent_attorney_address_1, agent_attorney_city,
agent_attorney_state_province, agent_attorney_postal_code, agent_attorney_email
from disclosure_test.disclosure_raw) t;

