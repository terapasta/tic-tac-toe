# from unittest import TestCase
# from nose.tools import ok_, eq_
#
# from learning.core.learn.bot import Bot
# from learning.core.learn.learning_parameter import LearningParameter
# from learning.core.predict.reply import Reply
# from learning.tests import helper
#
#
# class MyopeInfoConversationTestCase(TestCase):
#
#     def setUp(self):
#         self.csv_file_path = 'learning/tests/engine/fixtures/test_myope_info_conversation.csv'
#         self.bot_id = 997  # テスト用のbot_id いずれの値でも動作する
#         self.threshold = 0.6
#         self.answers = helper.build_answers(self.csv_file_path, encoding='SHIFT-JIS')
#         self.learning_parameter = LearningParameter({
#             'include_failed_data': False,
#             'include_tag_vector': False,
#             'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION,
#             # 'params_for_algorithm': {'C': 200}
#         })
#
#         # 学習処理は時間がかかるためmodelのdumpファイルを作ったらコメントアウトしてもテスト実行可能
#         _evaluator = Bot(self.bot_id, self.learning_parameter).learn(csv_file_path=self.csv_file_path)
#
#     def test_how_to_add_mail_signature(self):
#         questions = ['']
#         results = Reply(self.bot_id, self.learning_parameter).predict(questions)
#         answer_id = results[0]['answer_id']  # HACK Resultsクラスなどを作ってアクセスをシンプルにしたい。その前にmyope_server#replyのテスト実装が必要
#         probability = results[0]['probability']
#         answer_body = helper.get_answer_body(self.answers, answer_id)
#
#         expected_answer = """回答失敗しました"""
#         eq_(helper.replace_newline(answer_body), helper.replace_newline(expected_answer))
#         ok_(probability > self.threshold)
