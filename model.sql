-- Warning: You can generate script only for one table/view at a time in your Free plan 
-- 
-- *************** SqlDBM: PostgreSQL ****************;
-- ***************************************************;


-- ************************************** case_fact

CREATE TABLE case_fact
(
 case_status            text NOT NULL,
 agent_attorney_key     integer NOT NULL,
 original_file_date_key integer NOT NULL,
 employer_key           integer NOT NULL,
 decision_date_key      integer NOT NULL,
 received_date_key      integer NOT NULL,
 refile                 boolean NOT NULL,
 scheduled_sheepherder  boolean NOT NULL,
 employer_num_employees integer NOT NULL,
 employee_key           int NOT NULL,
 case_number            text NOT NULL,
 CONSTRAINT PK_9 PRIMARY KEY ( case_number ),
 CONSTRAINT FK_131 FOREIGN KEY ( agent_attorney_key ) REFERENCES agent_attorney_dim ( agent_attorney_key ),
 CONSTRAINT FK_134 FOREIGN KEY ( employee_key ) REFERENCES employee_dim ( employee_key ),
 CONSTRAINT FK_88 FOREIGN KEY ( received_date_key ) REFERENCES date_dim ( date_key ),
 CONSTRAINT FK_91 FOREIGN KEY ( decision_date_key ) REFERENCES date_dim ( date_key ),
 CONSTRAINT FK_94 FOREIGN KEY ( employer_key ) REFERENCES employer_dim ( employer_key ),
 CONSTRAINT FK_97 FOREIGN KEY ( original_file_date_key ) REFERENCES date_dim ( date_key )
);

CREATE INDEX fkIdx_133 ON case_fact
(
 agent_attorney_key
);

CREATE INDEX fkIdx_136 ON case_fact
(
 employee_key
);

CREATE INDEX fkIdx_90 ON case_fact
(
 received_date_key
);

CREATE INDEX fkIdx_93 ON case_fact
(
 decision_date_key
);

CREATE INDEX fkIdx_96 ON case_fact
(
 employer_key
);

CREATE INDEX fkIdx_99 ON case_fact
(
 original_file_date_key
);

-- ************************************** agent_attorney_dim

CREATE TABLE agent_attorney_dim
(
 agent_attorney_key            integer NOT NULL,
 agent_attorney_name           text NOT NULL,
 agent_attorney_firm_name      text NOT NULL,
 agent_attorney_phone          text NOT NULL,
 agent_attorney_phone_ext      text NOT NULL,
 agent_attorney_address1       text NOT NULL,
 agent_attorney_address2       text NOT NULL,
 agent_attorney_city           text NOT NULL,
 agent_attorney_state_province text NOT NULL,
 agent_attorney_postal_code    text NOT NULL,
 agent_attorney_email          text NOT NULL,
 CONSTRAINT PK_120 PRIMARY KEY ( agent_attorney_key )
);

-- ************************************** date_dim

CREATE TABLE date_dim
(
 "date"     date NOT NULL,
 month    numeric NOT NULL,
 day      numeric NOT NULL,
 year     numeric NOT NULL,
 quarter  numeric NOT NULL,
 date_key integer NOT NULL,
 CONSTRAINT PK_13 PRIMARY KEY ( date_key )
);


-- ************************************** employee_dim

CREATE TABLE employee_dim
(
 employee_key                    int NOT NULL,
 employee_contact_name           text NOT NULL,
 employee_contact_address1       text NOT NULL,
 employee_contact_address2       text NOT NULL,
 employee_contact_city           text NOT NULL,
 employee_contact_state_province text NOT NULL,
 employee_contact_country        text NOT NULL,
 employee_contact_postal_code    text NOT NULL,
 employee_contact_phone          text NOT NULL,
 emlpoyee_contact_email          text NOT NULL,
 CONSTRAINT PK_101 PRIMARY KEY ( employee_key )
);


-- ************************************** employer_dim

CREATE TABLE employer_dim
(
 employer_key                    integer NOT NULL,
 employer_name                   text NOT NULL,
 employer_phone_number           text NOT NULL,
 employer_ext                    text NOT NULL,
 employer_address1               text NOT NULL,
 employer_address2               text NOT NULL,
 employer_city                   text NOT NULL,
 employer_state_province         text NOT NULL,
 employer_country                text NOT NULL,
 employer_postal_code            text NOT NULL,
 employer_phone                  text NOT NULL,
 employer_phone_ext              text NOT NULL,
 employer_year_commence_business text NOT NULL,
 employer_naics_code             text NOT NULL,
 CONSTRAINT PK_28 PRIMARY KEY ( employer_key )
);









