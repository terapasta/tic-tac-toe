from unittest import TestCase
from nose.tools import ok_, eq_

from learning.core.learn.bot import Bot
from learning.core.predict.reply import Reply
from learning.tests import helper


class ToyotsuHumanConversationTestCase(TestCase):
    csv_file_path = './fixtures/learning_training_messages/toyotsu_human.csv'
    bot_id = 13  # bot_id = 13 は豊通
    threshold = 0.43


    @classmethod
    def setUpClass(cls):
        cls.learning_parameter = helper.learning_parameter(use_similarity_classification=True)
        cls.answers = helper.build_answers(cls.csv_file_path)
        # 学習処理は時間がかかるためmodelのdumpファイルを作ったらコメントアウトしてもテスト実行可能
        # _evaluator = Bot(cls.bot_id, cls.learning_parameter).learn(datasource_type='csv')

    def test_jal_mileage(self):
        questions = ['JAL マイレージ 内訳']
        result = Reply(self.bot_id, self.learning_parameter).perform(questions, datasource_type='csv')
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
        questions = ['海外の出張費の精算の方法は？']
        result = Reply(self.bot_id, self.learning_parameter).perform(questions, datasource_type='csv')
        answer_body = helper.get_answer_body(self.answers, result.answer_id)

        expected_answer = '''
TTCライブラリーにて掲載しているマニュアルを確認して下さい。
https://twins-a3.toyotsu.co.jp/AP0103/KeijiPub.nsf/vwDocNo-Link-Teikei/T031295?OpenDocument
'''

        eq_(helper.replace_newline_and_space(answer_body), helper.replace_newline_and_space(expected_answer))
        ok_(result.probability > self.threshold)


    def test_dont_know_account_item_of_visa(self):
        questions = ['VISAの勘定科目がわからない']
        result = Reply(self.bot_id, self.learning_parameter).perform(questions, datasource_type='csv')
        answer_body = helper.get_answer_body(self.answers, result.answer_id)

        expected_answer = '''
9238：支払手数料　※注意：入出国空港税（9311）と間違えないこと
'''
        eq_(helper.replace_newline_and_space(answer_body), helper.replace_newline_and_space(expected_answer))
        ok_(result.probability > self.threshold)


    def test_borned_child(self):
        questions = ['子供が生まれた']
        result = Reply(self.bot_id, self.learning_parameter).perform(questions, datasource_type='csv')
        answer_body = helper.get_answer_body(self.answers, result.answer_id)

        expected_answer = '''
TWNIS「TTCﾗｲﾌﾞﾗﾘｰ」→「扶養」で検索のうえ、「扶養異動届」を委託先の弁護士法人クローバーへ提出して下さい。
'''

        eq_(helper.replace_newline_and_space(answer_body), helper.replace_newline_and_space(expected_answer))
        ok_(result.probability > self.threshold)


    def test_insurance_card(self):
        questions = ['保険証をなくした']
        result = Reply(self.bot_id, self.learning_parameter).perform(questions, datasource_type='csv')
        answer_body = helper.get_answer_body(self.answers, result.answer_id)

        expected_answer = '''
TWNIS「TTCﾗｲﾌﾞﾗﾘｰ」を確認し、委託先の弁護士法人クローバーへ関係書類を提出して下さい。
https://twins-a3.toyotsu.co.jp/AP0103/KeijiPub.nsf/vwDocNo-Link-Teikei/T000818?OpenDocument
'''

        eq_(helper.replace_newline_and_space(answer_body), helper.replace_newline_and_space(expected_answer))
        ok_(result.probability > self.threshold)
