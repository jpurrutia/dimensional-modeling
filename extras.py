
class PsycopgTest():

    def __init__(self,df):
        self.df = df

    def connect(self):
        conn_string = "host={0} user={1} dbname={2} password={3}".format('localhost',
                                                                         'jpurrutia',
                                                                         'postgres', '710Camelotln!')
        self.connection = psycopg2.connect(conn_string)
        self.cursor = self.connection.cursor()

    #def create_table(self):
    #    self.cursor.execute(
    #        "CREATE TABLE IF NOT EXISTS {table} (id INT PRIMARY KEY, NAME text)".format(table=TABLE_NAME))
    #    self.connection.commit()
#
    #def truncate_table(self):
    #    self.cursor.execute("TRUNCATE TABLE {table} RESTART IDENTITY".format(table=TABLE_NAME))
    #    self.connection.commit()
        
    @measure_time
    def method_execute(self, values):
        """Loop over the dataset and insert every row separately"""
        for value in values:
            self.cursor.execute("INSERT INTO {table} VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)".format(table=TABLE_NAME), value)
        self.connection.commit()

    @measure_time
    def method_execute_many(self, values):
        self.cursor.executemany("INSERT INTO {table} VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)".format(table=TABLE_NAME), df)
        self.connection.commit()

    @measure_time
    def method_execute_batch(self, values):
        psycopg2.extras.execute_batch(self.cursor, "INSERT INTO {table} VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)".format(table=TABLE_NAME),
                                      values)
        self.connection.commit()

    @measure_time
    def method_string_building(self, values):
        argument_string = ",".join("('%s', '%s')" % (x, y) for (x, y) in values)
        self.cursor.execute("INSERT INTO {table} VALUES".format(table=TABLE_NAME) + argument_string)
        self.connection.commit()


def main():
    psyco = PsycopgTest(df)
    psyco.connect()
    #values = psyco.create_dummy_data()
    #psyco.create_table()
    #psyco.truncate_table()
    #psyco.method_execute(values=values)
    psyco.method_execute_many(values=df)
    # psyco.method_execute_batch(values=values)
    # psyco.method_string_building(values=values)