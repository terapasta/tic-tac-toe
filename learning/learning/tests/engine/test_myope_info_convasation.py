from unittest import TestCase

import pandas as pd
from nose.tools import ok_, eq_

from learning.core.learn.bot import Bot
from learning.core.learn.learning_parameter import LearningParameter
from learning.core.predict.reply import Reply


class MyopeInfoConvasationTestCase(TestCase):
    learning_parameter = LearningParameter({
        'include_failed_data': False,
        'include_tag_vector': False,
        'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION
    })
    threshold = 0.4
    bot_id = 999  # テスト用のbot_id いずれの値でも動作する
    csv_file_path = 'learning/tests/engine/fixtures/test_myope_info_convasation.csv'
    answers = None

    def setUp(self):
        self.answers = self.__build_answers()
        evaluator = Bot(self.bot_id, self.learning_parameter).learn(csv_file_path=self.csv_file_path)

    def test_how_is_security(self):
        questions = ['セキュリティはどう？']
        results = Reply(self.bot_id, self.learning_parameter).predict(questions)
        answer_id = results[0]['answer_id']
        probability = results[0]['probability']
        answer_body = self.__get_answer_body(answer_id)

        eq_(answer_body, 'セキュリティ対策については、ファイアウォールやSSL接続などの一般的な対策は行っております。利用ドメイン制限やIP制限など、更にセキュリティ強化の機能も実装を予定しております。')
        ok_(probability > self.threshold)

    def __get_answer_body(self, answer_id):
        rows = self.answers.query('answer_id == %s' % answer_id)
        return rows.iloc[0]['answer_body']

    def __build_answers(self):
        learning_training_messages = pd.read_csv(self.csv_file_path, encoding='SHIFT-JIS')
        return learning_training_messages.drop_duplicates(subset=['answer_id'])

