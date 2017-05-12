from unittest import TestCase
from nose.tools import ok_, eq_

from learning.core.learn.learning_parameter import LearningParameter
from learning.core.learn.bot import Bot
from learning.core.predict.reply import Reply
from learning.tests import helper


class BenefitoneConversationMLPTestCase(TestCase):
    bot_id = 11
    threshold = 0.5
    learning_parameter = helper.learning_parameter(algorithm=LearningParameter.ALGORITHM_NEURAL_NETWORK)

    @classmethod
    def setUpClass(cls):
        csv_file_path = './fixtures/learning_training_messages/benefitone.csv'
        cls.answers = helper.build_answers(csv_file_path)
        # 学習処理は時間がかかるためmodelのdumpファイルを作ったらコメントアウトしてもテスト実行可能
        # _evaluator = Bot(cls.bot_id, cls.learning_parameter).learn(datasource_type='csv')

    def test_want_to_check_contract(self):
        questions = ['契約書を見たいのですが']
        result = Reply(self.bot_id, self.learning_parameter).perform(questions)
        answer_body = helper.get_answer_body(self.answers, result.answer_id)

        expected_answer = '保管されている契約書ですか？'
        eq_(answer_body, expected_answer)
        ok_(result.probability > self.threshold)

    def test_please_rent_excard(self):
        questions = ['EXカードを貸してください']
        result = Reply(self.bot_id, self.learning_parameter).perform(questions)
        answer_body = helper.get_answer_body(self.answers, result.answer_id)

        expected_answer = 'レンタカー利用ですね。初めて利用しますか？'
        eq_(answer_body, expected_answer)
        ok_(result.probability > self.threshold)


    def test_fail_blank(self):
        '''
            抽出featureがない場合
            期待する動き＝分類失敗になること
              ラベル0に分類されるか、probaがしきい値以下であること
        '''
        questions = ['']
        result = Reply(self.bot_id, self.learning_parameter).perform(questions)

        ok_(result.answer_id == Reply.CLASSIFY_FAILED_ANSWER_ID or result.probability < self.threshold)

    # TODO
    # def test_dislike_carrot(self):
    #     '''
    #         抽出featureがある場合
    #         期待する動き＝分類失敗になること
    #           ラベル0に分類されるか、probaがしきい値以下であること
    #     '''
    #     questions = ['ニンジンが嫌いなので出さないでください']
    #     result = Reply(self.bot_id, self.learning_parameter).perform(questions)
    #
    #     ok_(result.answer_id == Reply.CLASSIFY_FAILED_ANSWER_ID or result.probability < self.threshold)
