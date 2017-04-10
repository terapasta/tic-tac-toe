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
        _evaluator = Bot(cls.bot_id, helper.learning_parameter()).learn(csv_file_path=cls.csv_file_path)

    def test_hoge(self):
        ok_(True)

    # def test_want_to_check_contract(self):
    #     questions = ['契約書を見たいのですが']
    #     result = Reply(self.bot_id, helper.learning_parameter()).perform(questions)
    #     answer_body = helper.get_answer_body(self.answers, result.answer_id)
    #
    #     expected_answer = '保管されている契約書ですか？'
    #     eq_(answer_body, expected_answer)
    #     ok_(result.probability > self.threshold)
    #
    # def test_please_rent_excard(self):
    #     questions = ['EXカードを貸してください']
    #     result = Reply(self.bot_id, helper.learning_parameter()).perform(questions)
    #     answer_body = helper.get_answer_body(self.answers, result.answer_id)
    #
    #     expected_answer = 'それでは、総務部の方に確認してください。　総務の人は、田中さん（内線801401）、中島さん（内線801402）、渡辺さん（内線801403）です。'
    #     eq_(answer_body, expected_answer)
    #     ok_(result.probability > self.threshold)
