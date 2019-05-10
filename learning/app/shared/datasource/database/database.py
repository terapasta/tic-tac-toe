# Oracle の MySQL公式ページで採用されている mysql-connector-python を使用する
# https://dev.mysql.com/doc/connector-python/en/connector-python-introduction.html
import mysql.connector

import time
import pandas as pd
from app.shared.config import Config
from app.shared.logger import logger


class Database():
    __shared_state = {}

    def __init__(self):
        self.__dict__ = self.__shared_state
        self._db_config = Config().get('database')
        self._max_retry = self._db_config['max_retry']
        self._retry_interval = self._db_config['retry_interval'] / 1000.0

        # リトライ回数
        self._n_retry = 0

    def select(self, sql, params):
        def my_execute(conn):
            data = pd.read_sql(sql, conn, params=params)
            return data
        data = self._execute_with_connect(my_execute)
        return data

    def execute(self, sql, params):
        def my_execute(conn):
            cur = conn.cursor(buffered=False)
            cur.execute(sql, params)
        self._execute_with_connect(my_execute)

    def execute_with_transaction(self, queries):
        def my_execute(conn):
            cur = conn.cursor(buffered=False)
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
        except (mysql.connector.Error, pd.io.sql.DatabaseError) as e:
            logger.warn(e)
            raise(e)

        finally:
            # commit しないとキャッシュを使用してしまう
            conn.commit()
            conn.close()

    def _connect(self):
        logger.info('trying to connect database')
        try:
            conn = mysql.connector.connect(
                host=self._db_config['host'],
                database=self._db_config['name'],
                user=self._db_config['user'],
                password=self._db_config['password'],
                charset='utf8',

                # 接続時に connection pooling を使用する
                # https://dev.mysql.com/doc/connector-python/en/connector-python-connection-pooling.html
                pool_size=self._db_config['pool'],
                pool_name=self._db_config['pool_name'],
            )
            # 接続に成功したら retry回数をリセット
            self._n_retry = 0

            return conn

        # pool が足りない場合
        except mysql.connector.errors.PoolError as e:
            logger.warn(e)

            # リトライ回数が上限に達したら、接続を諦める
            if self._n_retry >= self._max_retry:
                raise(e)

            # リトライ回数を更新
            self._n_retry += 1

            time.sleep(self._retry_interval) # msec -> sec
            return self._connect()
