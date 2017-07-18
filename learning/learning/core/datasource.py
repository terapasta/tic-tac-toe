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
            self._learning_training_messages = self.__build_data_from_csv('learning_training_messages')
            self._question_answers = self.__build_data_from_csv('question_answers')


    def __connect_db(self):
        config = Config()
        dbconfig = config.get('database')
        db = MySQLdb.connect(host=dbconfig['host'], db=dbconfig['name'], user=dbconfig['user'],
                             passwd=dbconfig['password'], charset='utf8')
        return db


    def __build_data_from_csv(self, table_name):
        arr = []
        files = glob.glob('./fixtures/%s/*' % table_name)
        logger.debug(files)

        for file in files:
            df = pd.read_csv(file)
            arr.append(df)

        data = pd.concat(arr)
        return data


    def learning_training_messages(self, bot_id):
        if self._type == 'database':
            data = pd.read_sql("select * from learning_training_messages where bot_id = %(bot_id)s;", self._db, params={"bot_id": bot_id})
        elif self._type == 'csv':
            data = self._learning_training_messages[self._learning_training_messages['bot_id'] == bot_id]

        return data

    def all_learning_training_messages(self):
        '''
            利用可能な全Botの学習セットを戻す
        '''
        if self._type == 'database':
            data = pd.read_sql("select * from learning_training_messages;", self._db)
        elif self._type == 'csv':
            data = self._learning_training_messages

        return data


    def question_answers(self, bot_id):
        from learning.core.predict.reply import Reply

        if self._type == 'database':
            data = pd.read_sql(
                "select id, question, from question_answers where bot_id = %(bot_id)s and id <> %(id)s;",
                self._db, params={"bot_id": bot_id, "id": Reply.CLASSIFY_FAILED_ANSWER_ID})
        elif self._type == 'csv':
            data = self._question_answers[self._question_answers['bot_id'] == bot_id]
            data = data[data['id'] != Reply.CLASSIFY_FAILED_ANSWER_ID]

        return data

    def question_answers_for_suggest(self, bot_id, question):
        from learning.core.predict.reply import Reply

        if self._type == 'database':
            data = pd.read_sql(
                "select id, question from question_answers where bot_id = %(bot_id)s and question <> %(question)s and id <> %(id)s;",
                self._db, params={"bot_id": bot_id, "question": question, "id": Reply.CLASSIFY_FAILED_ANSWER_ID})
        elif self._type == 'csv':
            data = self._question_answers[self._question_answers['bot_id'] == bot_id]
            data = data[data['id'] != Reply.CLASSIFY_FAILED_ANSWER_ID]
            data = data[data['question'] != question]

        return data

    # TODO learning_training_messagesと共通化したい(同一のクエスチョンを除外しているだけの違いなので出来るはず)
    def learning_training_messages_for_suggest(self, bot_id, question):
        from learning.core.predict.reply import Reply

        if self._type == 'database':
            data = pd.read_sql(
                "select id, question, question_answer_id from learning_training_messages where bot_id = %(bot_id)s and question <> %(question)s and question_answer_id <> %(question_answer_id)s;",
                self._db, params={"bot_id": bot_id, "question": question, "question_answer_id": Reply.CLASSIFY_FAILED_ANSWER_ID})
        elif self._type == 'csv':
            data = self._learning_training_messages[self._learning_training_messages['bot_id'] == bot_id]
            data = data[data['question_answer_id'] != Reply.CLASSIFY_FAILED_ANSWER_ID]
            data = data[data['question'] != question]

        return data
