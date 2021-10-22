import pandas as pd
import psycopg2.extras as extras
from db import local_dbc

df = pd.read_csv('disclosure_data.csv', encoding='utf-8')

df.columns = [col.lower() for col in df.columns]

#  ******************************************************************** Subset dataframe
df = df[['case_number',
'case_status', 'received_date', 'decision_date', 'refile',
'schd_a_sheepherder', 'employer_name', 'employer_address_1',
'employer_address_2', 'employer_city', 'employer_state_province',
'employer_country', 'employer_postal_code', 'employer_phone',
'employer_num_employees', 'employer_year_commenced_business',
'naics_code', 'fw_ownership_interest', 'emp_contact_name',
'emp_contact_address_1', 'emp_contact_address_2', 'emp_contact_city',
'emp_contact_state_province', 'emp_contact_country', 'emp_contact_postal_code',
'emp_contact_phone', 'emp_contact_email', 'agent_attorney_name',
'agent_attorney_firm_name', 'agent_attorney_phone', 'agent_attorney_address_1',
'agent_attorney_city', 'agent_attorney_state_province', 'agent_attorney_country',
'agent_attorney_postal_code', 'agent_attorney_email']]

# ******************************************************************** Checking Data Quality
percent_missing = df.isnull().sum() * 100 / len(df)

missing_value_df = pd.DataFrame({'column_name': df.columns,
                                 'percent_missing': percent_missing})

print(missing_value_df.head(100))

# ******************************************************************** testing bulk insert --> turn into function
# load csv into df

# connect to db and set cursor
db = local_dbc()
cur = db.cursor()

# set table/columns vars
table = 'disclosure_test.disclosure_raw'
cols = ','.join(list(df.columns))

# convert rows into tuples
tuples = [tuple(x) for x in df.to_numpy()]

# set sql query for insert statement
sql = "INSERT INTO %s(%s) VALUES %%s" % (table, cols)

# bulk insert values into table
extras.execute_values(cur, sql, tuples)

# commit changes
db.commit()