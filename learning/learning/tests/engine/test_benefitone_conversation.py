from unittest import TestCase
from nose.tools import ok_, eq_

from learning.core.learn.bot import Bot
from learning.core.predict.reply import Reply
from learning.tests import helper


class BenefitoneConversationTestCase(TestCase):
    csv_file_path = './fixtures/learning_training_messages/benefitone.csv'
    bot_id = 11
    threshold = 0.5

    @classmethod
    def setUpClass(cls):
        cls.learning_parameter = helper.learning_parameter(use_similarity_classification=True)
        cls.question_answers = helper.build_question_answers(cls.csv_file_path)
        # 学習処理は時間がかかるためmodelのdumpファイルを作ったらコメントアウトしてもテスト実行可能
        _evaluator = Bot(cls.bot_id, helper.learning_parameter(use_similarity_classification=True)).learn(datasource_type='csv')

    def test_want_to_check_contract(self):
        questions = ['契約書を見たいのですが']
        result = Reply(self.bot_id, self.learning_parameter).perform(questions, datasource_type='csv')
        answer_body = helper.get_answer(self.question_answers, result.question_answer_id)

        expected_answer = '保管されている契約書ですか？'
        eq_(answer_body, expected_answer)
        ok_(result.probability > self.threshold)

    def test_please_rent_excard(self):
        questions = ['EXカードを貸してください']
        result = Reply(self.bot_id, self.learning_parameter).perform(questions, datasource_type='csv')
        answer_body = helper.get_answer(self.question_answers, result.question_answer_id)

        expected_answer = 'レンタカー利用ですね。初めて利用しますか？'
        eq_(answer_body, expected_answer)
        ok_(result.probability > self.threshold)


    # # TODO 不均衡データが原因で、分類失敗出来ず、「それでは、総武の方に〜」が選択されてしまう
    # def test_dislike_carrot(self):
    #     questions = ['ニンジンが嫌いなので出さないでください']
    #     results = Reply(self.bot_id, self.learning_parameter).predict(questions)
    #     probability = results[0]['probability']
    #
    #     # しきい値を超える回答がないこと
    #     ok_(probability < self.threshold)
    #
    # def test_fail_blank(self):
    #     questions = ['']
    #     result = Reply(self.bot_id, helper.learning_parameter(use_similarity_classification=False)).perform(questions)
    #
    #     # ラベル0(分類失敗)に分類されること
    #     eq_(result.question_answer_id, Reply.CLASSIFY_FAILED_ANSWER_ID)
    #     ok_(result.probability > self.threshold)


