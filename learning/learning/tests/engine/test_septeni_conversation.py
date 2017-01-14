from unittest import TestCase
from nose.tools import ok_, eq_

from learning.core.learn.learning_parameter import LearningParameter
from learning.core.predict.reply import Reply
from learning.tests import helper


class SepteniConversationTestCase(TestCase):

    def setUp(self):
        self.learning_parameter = LearningParameter({
            'include_failed_data': False,
            'include_tag_vector': False,
            'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION
        })
        self.threshold = 0.5
        self.bot_id = 999  # テスト用のbot_id いずれの値でも動作する
        self.csv_file_path = 'learning/tests/engine/fixtures/test_septeni_conversation.csv'
        self.answers = helper.build_answers(self.csv_file_path, encoding='SHIFT-JIS')

        # _evaluator = Bot(self.bot_id, self.learning_parameter).learn(csv_file_path=self.csv_file_path)

    def test_can_not_connect_akindo(self):
        questions = ['akindoに接続出来ない']
        results = Reply(self.bot_id, self.learning_parameter).predict(questions)
        answer_id = results[0]['answer_id']
        probability = results[0]['probability']
        answer_body = helper.get_answer_body(self.answers, answer_id)

        eq_(answer_body, '情シスFAQサイトに解決方法が載っていますので、下記のURLより参照をお願いします\rhttp://faq.septeni.jp/index.php?doc_no=46')
        ok_(probability > self.threshold)