from datetime import datetime
from learning.config.config import Config
from learning.core.singleton import Singleton
import MySQLdb

class Database(metaclass=Singleton):
    def __init__(self):
        # TODO DB生成をDryにしたい
        config = Config()
        dbconfig = config.get('database')
        self._connection = MySQLdb.connect(host=dbconfig['host'], db=dbconfig['name'], user=dbconfig['user'], passwd=dbconfig['password'], charset='utf8')

    @property
    def connection(self):
        return self._connection
