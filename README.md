# Data Modeling 

## Process Components

- Dataset
- Data Modeling (SQL)
- ETL (Python)
- Database Connection


### Dataset
Per the U.S. Department of Labor (https://www.dol.gov/agencies/eta/foreign-labor/performance)

Disclosure data consists of selected information extracted from nonimmigrant and immigrant application tables within the Office of Foreign Labor Certification's case management systems. The data sets provide public access to the latest quarterly and annual data in easily accessible formats for the purpose of performing in-depth longitudinal research and analysis. Each data set is cumulative for the fiscal year, containing unique records identified by the applicable OFLC case number based on the most recent date a case determination decision was issued. Information that appears in these records is provided by employers and system-generated metadata, such as received dates and decision dates. Any typographical errors or other data anomalies (e.g., incomplete or blank data fields, etc.) may be due to internal data entry or other external customer errors in completing and submitting the applications for processing.

### Data Modeling

The data modeling component of this project is focused on a start schema approach with one fact table and four dimension tables.

![Alt text](./img/schema.png)

Fact:
- Case

Dimension:
- Employer
- Agent Attorney
- Date
- Employee



### ETL

### Database Connection