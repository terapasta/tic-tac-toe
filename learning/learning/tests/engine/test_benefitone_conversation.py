from unittest import TestCase
from nose.tools import ok_, eq_

from learning.core.learn.bot import Bot
from learning.core.learn.learning_parameter import LearningParameter
from learning.core.predict.reply import Reply
from learning.tests import helper


class BenefitoneConversationTestCase(TestCase):
    csv_file_path = 'learning/tests/engine/fixtures/test_benefitone_conversation.csv'
    bot_id = 995  # テスト用のbot_id いずれの値でも動作する
    threshold = 0.5
    learning_parameter = LearningParameter({
        'include_failed_data': False,
        'include_tag_vector': False,
        'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION,
    })

    @classmethod
    def setUpClass(cls):
        cls.answers = helper.build_answers(cls.csv_file_path)
        # 学習処理は時間がかかるためmodelのdumpファイルを作ったらコメントアウトしてもテスト実行可能
        _evaluator = Bot(cls.bot_id, cls.learning_parameter).learn(csv_file_path=cls.csv_file_path)

    def test_want_to_check_contract(self):
        questions = ['契約書を見たいのですが']
        results = Reply(self.bot_id, self.learning_parameter).predict(questions)
        answer_id = results[0]['answer_id']  # HACK Resultsクラスなどを作ってアクセスをシンプルにしたい。その前にmyope_server#replyのテスト実装が必要
        probability = results[0]['probability']
        answer_body = helper.get_answer_body(self.answers, answer_id)

        expected_answer = '保管されている契約書ですか？'
        eq_(answer_body, expected_answer)
        ok_(probability > self.threshold)