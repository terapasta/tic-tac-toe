import traceback
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
        def my_execute():
            data = pd.read_sql(sql, self.db, params=params)
            # Note: 常に最新のデータを取得するためにコミットする
            self.db.commit()
            return data
        data = self._execute_with_connect(my_execute)
        return data

    def execute(self, sql, params):
        def my_execute():
            with self.db as cur:
                cur.execute(sql, params)
        self._execute_with_connect(my_execute)

    def execute_with_transaction(self, queries):
        def my_execute():
            with self.db as cur:
                for query in queries:
                    cur.execute(query[0], query[1])
        self._execute_with_connect(my_execute)

    def _execute_with_connect(self, function):
        try:
            self._connect()
            return function()
        # NOTE: MYSQLに一定時間以上クエリーを実行しなかった場合に接続が切断されてしまうため再接続を行う
        #       https://www.pivotaltracker.com/n/projects/1879711/stories/151425115
        except (MySQLdb.Error, pd.io.sql.DatabaseError) as e:
            logger.error(traceback.format_exc())
            logger.info('try reconnect to database')
            try:
                self.db.close()
            except:
                logger.error(traceback.format_exc())

            self.db = None
            self._connect()
            return function()

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
        logger.info('database connected')
