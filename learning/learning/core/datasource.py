import MySQLdb

from learning.config.config import Config


class Datasource:
    def __init__(self, type='database'):
        self._type = type

        if type == 'database':
            self.db = self.__connect_db()

    def __connect_db(self):
        config = Config()
        dbconfig = config.get('database')
        db = MySQLdb.connect(host=dbconfig['host'], db=dbconfig['name'], user=dbconfig['user'],
                             passwd=dbconfig['password'], charset='utf8')
        return db
