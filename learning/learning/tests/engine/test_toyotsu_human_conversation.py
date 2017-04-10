from unittest import TestCase
from nose.tools import ok_, eq_

from learning.core.learn.bot import Bot
from learning.core.predict.reply import Reply
from learning.tests import helper


class ToyotsuHumanConversationTestCase(TestCase):
    csv_file_path = 'learning/tests/fixtures/test_toyotsu_human_conversation.csv'
    bot_id = 994  # テスト用のbot_id いずれの値でも動作する  # TODO Botごとに重複しないようにするのが手間なので、指定しないでも動くようにしたい
    threshold = 0.5

    @classmethod
    def setUpClass(cls):
        cls.answers = helper.build_answers(cls.csv_file_path)
        # 学習処理は時間がかかるためmodelのdumpファイルを作ったらコメントアウトしてもテスト実行可能
        # _evaluator = Bot(cls.bot_id, helper.learning_parameter()).learn(csv_file_path=cls.csv_file_path)

    def test_jal_mileage(self):
        questions = ['JAL マイレージ']
        result = Reply(self.bot_id, helper.learning_parameter()).perform(questions)
        answer_body = helper.get_answer_body(self.answers, result.answer_id)

        expected_answer = '''
JALマイレージバンクで計上される費用は
すべて海外出張時の費用となります。
そのうち、国内旅費で計上されるものは、
通常、国内空港使用料だと思いますが、
詳細は、こちらではわかりません。

旅行代理店から、航空券等発注の際、
控えをいただいていると思いますので、
そちらでご確認ください。
'''
        eq_(answer_body, expected_answer)
        ok_(result.probability > self.threshold)
