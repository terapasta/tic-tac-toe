import MySQLdb
import pandas as pd
from app.shared.config import Config


class Database():
    __shared_state = {}

    def __init__(self):
        self.__dict__ = self.__shared_state

    def connect(self):
        dbconfig = Config().get('database')
        self.db = MySQLdb.connect(
                host=dbconfig['host'],
                db=dbconfig['name'],
                user=dbconfig['user'],
                passwd=dbconfig['password'],
                charset='utf8',
            )

    def select(self, sql, params):
        return pd.read_sql(sql, self.db, params=params)
