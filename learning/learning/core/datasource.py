import MySQLdb
import pandas as pd

from learning.config.config import Config


class Datasource:
    def __init__(self, type='database'):
        self._type = type

        if type == 'database':
            self._db = self.__connect_db()

    def __connect_db(self):
        config = Config()
        dbconfig = config.get('database')
        db = MySQLdb.connect(host=dbconfig['host'], db=dbconfig['name'], user=dbconfig['user'],
                             passwd=dbconfig['password'], charset='utf8')
        return db


    def learning_training_messages(self, bot_id):
        if self._type == 'database':
            data = pd.read_sql("select * from learning_training_messages where bot_id = %s;" % bot_id, self._db)
        return data
