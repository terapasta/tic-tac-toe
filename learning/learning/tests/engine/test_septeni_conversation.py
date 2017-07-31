# セプテーニは現在利用していないためコメントアウト
# from unittest import SkipTest
# from unittest import TestCase
#
# import pandas as pd
# from nose.tools import ok_, eq_
#
# from learning.core.learn.bot import Bot
# from learning.core.learn.learning_parameter import LearningParameter
# from learning.core.predict.reply import Reply
# from learning.tests import helper
#
#
# class SepteniConvasationTestCase(TestCase):
#     threshold = 0.5
#     bot_id = 9  # bot_id = 9はセプテーニ
#     csv_file_path = './fixtures/learning_training_messages/septeni.csv'
#
#     @classmethod
#     def setUpClass(cls):
#         cls.answers = helper.build_answers(cls.csv_file_path)
#         cls.learning_parameter = helper.learning_parameter(use_similarity_classification=False)
#         _evaluator = Bot(cls.bot_id, cls.learning_parameter).learn(datasource_type='csv')
#
#     # def test_stop(self):
#     #     questions = ['やめる']
#     #     result = Reply(self.bot_id, self.learning_parameter).perform(questions, datasource_type='csv')
#     #
#     #     answer_body = helper.get_answer_body(self.answers, result.answer_id)
#     #     ok_(result.probability < self.threshold)
#
#
#     # def test_can_not_connect_akindo(self):
#     #     questions = ['akindoに接続出来ない']
#     #     results = Reply(self.bot_id, self.learning_parameter).predict(questions)
#     #     answer_id = results[0]['answer_id']
#     #     probability = results[0]['probability']
#     #     answer_body = self.__get_answer_body(answer_id)
#     #
#     #     eq_(answer_body, '情シスFAQサイトに解決方法が載っていますので、下記のURLより参照をお願いします\rhttp://faq.septeni.jp/index.php?doc_no=46')
#     #     ok_(probability > self.threshold)
#     #
#     # def test_printer_driver(self):
#     #     questions = ['プリンタ ドライバ']
#     #     results = Reply(self.bot_id, self.learning_parameter).predict(questions)
#     #     answer_id = results[0]['answer_id']
#     #     probability = results[0]['probability']
#     #     answer_body = self.__get_answer_body(answer_id)
#     #
#     #     eq_(answer_body, 'インストールしたいドライバが格納されているフォルダごとPCのデスクトップ上にコピーしていますか')
#     #     ok_(probability > self.threshold)
#     #
#     # def test_add_memory(self):
#     #     questions = ['PCにメモリを増設したい']
#     #     results = Reply(self.bot_id, self.learning_parameter).predict(questions)
#     #     answer_id = results[0]['answer_id']
#     #     probability = results[0]['probability']
#     #     answer_body = self.__get_answer_body(answer_id)
#     #
#     #     eq_(answer_body, 'PCへのメモリ増設についてですね。\r\n\r\n使用しているPCの種類は何ですか？\r\n')
#     #     ok_(probability > self.threshold)
#     #
#     # def __get_answer_body(self, answer_id):
#     #     rows = self.answers.query('answer_id == %s' % answer_id)
#     #     return rows.iloc[0]['answer_body']
#     #