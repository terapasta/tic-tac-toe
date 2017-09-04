import MySQLdb
import pandas as pd
from app.shared.config import Config
from app.shared.logger import logger


class Database():
    __shared_state = {}
    db = None

    def __init__(self):
        self.__dict__ = self.__shared_state

    def select(self, sql, params):
        self._connect()
        return pd.read_sql(sql, self.db, params=params)

    def _connect(self):
        if self.db is not None:
            return

        dbconfig = Config().get('database')
        self.db = MySQLdb.connect(
                host=dbconfig['host'],
                db=dbconfig['name'],
                user=dbconfig['user'],
                passwd=dbconfig['password'],
                charset='utf8',
            )
        # Note: mysqlで別コネクションの最新のデータをselectするための設定
        self.db.autocommit(True)
        logger.info('database connected')
