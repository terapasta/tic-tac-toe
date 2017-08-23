import MySQLdb
import pandas as pd
from app.shared.config import Config
from app.shared.logger import logger


class Database():
    __shared_state = {}
    is_connected = False

    def __init__(self):
        self.__dict__ = self.__shared_state

    def select(self, sql, params):
        self._connect()
        return pd.read_sql(sql, self.db, params=params)

    def _connect(self):
        logger.debug('connect start')
        if self.is_connected is True:
            return

        logger.debug('connect!!!!!!')
        dbconfig = Config().get('database')
        self.db = MySQLdb.connect(
                host=dbconfig['host'],
                db=dbconfig['name'],
                user=dbconfig['user'],
                passwd=dbconfig['password'],
                charset='utf8',
            )
        self.is_connected = True
