from unittest import TestCase
from nose.tools import ok_, eq_

from learning.core.learn.learning_parameter import LearningParameter
from learning.core.learn.bot import Bot
from learning.core.predict.reply import Reply
from learning.tests import helper


class ToyotsuHumanConversationTestCase(TestCase):
    csv_file_path = 'learning/tests/fixtures/test_toyotsu_human_conversation.csv'
    bot_id = 994  # テスト用のbot_id いずれの値でも動作する  # TODO Botごとに重複しないようにするのが手間なので、指定しないでも動くようにしたい
    threshold = 0.5
    learning_parameter = helper.learning_parameter(algorithm=LearningParameter.ALGORITHM_NEURAL_NETWORK)

    @classmethod
    def setUpClass(cls):
        cls.answers = helper.build_answers(cls.csv_file_path)
        # 学習処理は時間がかかるためmodelのdumpファイルを作ったらコメントアウトしてもテスト実行可能
        _evaluator = Bot(cls.bot_id, cls.learning_parameter).learn(csv_file_path=cls.csv_file_path)

    def test_jal_mileage(self):
        questions = ['JAL マイレージ']
        result = Reply(self.bot_id, self.learning_parameter).perform(questions)
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
        # HACK 「helper.replace_newline_and_space」の記述が長すぎるのでシンプルな書き方にしたい
        eq_(helper.replace_newline_and_space(answer_body), helper.replace_newline_and_space(expected_answer))
        ok_(result.probability > self.threshold)


    def test_overseas_business_trip_pay(self):
        questions = ['海外の出張費を精算したい']
        result = Reply(self.bot_id, self.learning_parameter).perform(questions)
        answer_body = helper.get_answer_body(self.answers, result.answer_id)

        expected_answer = '''
長期出張の場合は、1ヶ月毎の途中精算が原則になっています。
途中精算する際に通常の出張システムで精算してしまうと帰国したことになってしまうため、SAPの立替精算処理をしてください。
また、立替精算依頼書には費用計算書と領収書を添付の上、ＴＨＲまでご提出願います。
なお帰国された際は最終の精算のため、通常通り海外出張システムの精算届を作成します。精算届作成時の出張期間は実際の出発日・帰国日となりますが、日当支給日数は、途中精算した日数を引いてください。
'''
        eq_(helper.replace_newline_and_space(answer_body), helper.replace_newline_and_space(expected_answer))
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

    def test_dislike_carrot(self):
        '''
            抽出featureがある場合
            期待する動き＝分類失敗になること
              ラベル0に分類されるか、probaがしきい値以下であること
        '''
        questions = ['ニンジンが嫌いなので出さないでください']
        result = Reply(self.bot_id, self.learning_parameter).perform(questions)

        ok_(result.answer_id == Reply.CLASSIFY_FAILED_ANSWER_ID or result.probability < self.threshold)
