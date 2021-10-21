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



def df_to_table(conn, df, table):
    """
    Here we are going save the dataframe in memory 
    and use copy_from() to copy it to the table
    """
    # save dataframe to an in memory buffer
    conn = local_dbc()
    buffer = StringIO()
    df.to_csv(buffer, index=False, header=False)
    buffer.seek(0)
    cursor = conn.cursor()
    try:
        cursor.copy_from(buffer, table, sep=",")
        conn.commit()
    except (Exception, psycopg2.DatabaseError) as error:
        print(f"Error: {error}")
        conn.rollback()
        cursor.close()
        return buffer
    print("copy_from_stringio() done")
    cursor.close()
    return conn, buffer


def copy_from_file(conn, df, table):
    """
    Here we are going save the dataframe on disk as 
    a csv file, load the csv file  
    and use copy_from() to copy it to the table
    """
    tmp_df = "./tmp_dataframe.csv"
    df.reset_index(drop=True, inplace=True)
    df.to_csv(tmp_df, index=False, header=False, index_label=None)
    f = open(tmp_df, 'r')
    cursor = conn.cursor()
    try:
        cursor.copy_from(f, table, sep=',')
    except (Exception, psycopg2.DatabaseError) as error:
        os.remove(tmp_df)
        print(f"Error: {error}")
        conn.rollback()
        cursor.close()
        return 1
    print('copy_from_file() done')
    cursor.close()
    #os.remove(tmp_df)
