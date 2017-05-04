import glob

import MySQLdb
import pandas as pd

from learning.config.config import Config
from learning.log import logger


class Datasource:
    def __init__(self, type='database'):
        self._type = type

        if type == 'database':
            self._db = self.__connect_db()

        if type == 'csv':
            self._learning_training_messages = self.__build_learning_training_messages_from_csv()


    def __connect_db(self):
        config = Config()
        dbconfig = config.get('database')
        db = MySQLdb.connect(host=dbconfig['host'], db=dbconfig['name'], user=dbconfig['user'],
                             passwd=dbconfig['password'], charset='utf8')
        return db


    def __build_learning_training_messages_from_csv(self):
        arr = []
        files = glob.glob('./fixtures/learning_training_messages/*')
        logger.debug(files)

        for file in files:
            df = pd.read_csv(file)
            arr.append(df)

        data = pd.concat(arr)
        return data


    def learning_training_messages(self, bot_id):
        if self._type == 'database':
            data = pd.read_sql("select * from learning_training_messages where bot_id = %s;" % bot_id, self._db)
        elif self._type == 'csv':
            data = self._learning_training_messages[self._learning_training_messages['bot_id'] == bot_id]

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