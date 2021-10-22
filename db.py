import psycopg2
import os
from io import StringIO


# DATABASE CONNECTIONS
def local_dbc():
    conn = psycopg2.connect(host = os.environ['LOC_DB_HOST'],
                            user = os.environ['LOC_DB_USER'],
                            password = os.environ['LOC_DB_PWD'],
                            dbname = os.environ['LOC_DB_NAME'],
                            port = os.environ['LOC_DB_PORT'])
    return conn