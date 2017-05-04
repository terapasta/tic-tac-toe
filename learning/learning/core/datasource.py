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


    def store_data_from(self):
        return None

    def learning_training_messages(self, bot_id):
        if self._type == 'database':
            data = pd.read_sql("select * from learning_training_messages where bot_id = %s;" % bot_id, self._db)
        elif self._type == 'csv':
            data = None

        return data


    def question_answers(self, bot_id):
        from learning.core.predict.reply import Reply

        data = pd.read_sql(
            "select id, question, answer_id from question_answers where bot_id = %s and answer_id <> %s;"
            % (bot_id, Reply.CLASSIFY_FAILED_ANSWER_ID), self._db)
        return data

    def question_answers_for_suggest(self, bot_id, question):
        from learning.core.predict.reply import Reply
        data = pd.read_sql(
            "select id, question from question_answers where bot_id = %s and question <> '%s' and answer_id <> %s;"
            % (bot_id, question, Reply.CLASSIFY_FAILED_ANSWER_ID), self._db)
        return data