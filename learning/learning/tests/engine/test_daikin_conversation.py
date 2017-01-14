from unittest import TestCase
from unittest.mock import MagicMock, PropertyMock

import pandas as pd
from nose.tools import ok_, eq_

from learning.core.learn.bot import Bot
from learning.core.learn.learning_parameter import LearningParameter
from learning.core.predict.reply import Reply
from learning.config.config import Config


class DaikinConversationTestCase(TestCase):
    learning_parameter = LearningParameter({
        'include_failed_data': False,
        'include_tag_vector': False,
        'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION
    })
    threshold = 0.5
    bot_id = 998  # テスト用のbot_id いずれの値でも動作する
    csv_file_path = 'learning/tests/engine/fixtures/test_daikin_conversation.csv'
    answers = None

    def setUp(self):
        self.answers = self.__build_answers()
        _evaluator = Bot(self.bot_id, self.learning_parameter).learn(csv_file_path=self.csv_file_path)

    def test_hoge(self):
        ok_(True)
    #
    # def test_can_not_connect_akindo(self):
    #     questions = ['akindoに接続出来ない']
    #     results = Reply(self.bot_id, self.learning_parameter).predict(questions)
    #     answer_id = results[0]['answer_id']
    #     probability = results[0]['probability']
    #     answer_body = self.__get_answer_body(answer_id)
    #
    #     eq_(answer_body, '情シスFAQサイトに解決方法が載っていますので、下記のURLより参照をお願いします\rhttp://faq.septeni.jp/index.php?doc_no=46')
    #     ok_(probability > self.threshold)
    #
    # def __get_answer_body(self, answer_id):
    #     rows = self.answers.query('answer_id == %s' % answer_id)
    #     return rows.iloc[0]['answer_body']

    # TODO DRYにする
    def __build_answers(self):
        learning_training_messages = pd.read_csv(self.csv_file_path, encoding='SHIFT-JIS')
        return learning_training_messages.drop_duplicates(subset=['answer_id'])

