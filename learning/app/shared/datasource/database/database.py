import MySQLdb
import pandas as pd
from app.shared.config import Config
from app.shared.logger import logger


class Database():
    __shared_state = {}

    def __init__(self):
        self.__dict__ = self.__shared_state

    def select(self, sql, params):
        def my_execute(conn):
            data = pd.read_sql(sql, conn, params=params)
            return data
        data = self._execute_with_connect(my_execute)
        return data

    def execute(self, sql, params):
        def my_execute(conn):
            with conn as cur:
                cur.execute(sql, params)
        self._execute_with_connect(my_execute)

    def execute_with_transaction(self, queries):
        def my_execute(conn):
            with conn as cur:
                for query in queries:
                    cur.execute(query[0], query[1])
        self._execute_with_connect(my_execute)

    def _execute_with_connect(self, function):
        #
        # NOTE: コネクションを貼ろうとし続けて並列数が 3以上にできなかったので一旦
        #       エラーハンドリングを諦めて raise する
        #       https://www.pivotaltracker.com/n/projects/1879711/stories/165144559
        #
        conn = self._connect()
        try:
            return function(conn)

        #
        # FIXME: エラーが再度問題になった場合に、エラーハンドリングをちゃんと書く（リトライとか）
        #
        except (MySQLdb.Error, pd.io.sql.DatabaseError) as e:
            logger.warn(e)
            raise(e)

        finally:
            conn.close()

    def _connect(self):
        dbconfig = Config().get('database')
        logger.info('database connected')
        return MySQLdb.connect(
            host=dbconfig['host'],
            db=dbconfig['name'],
            user=dbconfig['user'],
            passwd=dbconfig['password'],
            charset='utf8',
        )
