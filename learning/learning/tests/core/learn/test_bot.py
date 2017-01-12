# import os
# from unittest import TestCase
#
# import mox
# from nose.tools import ok_, eq_
#
# from learning.core.learn.bot import Bot
# from learning.core.learn.learning_parameter import LearningParameter
# from learning.core.persistance import Persistance
# from learning.core.training_set.text_array import TextArray
# from learning.core.training_set.training_message import TrainingMessage
#
#
# class BotTestCase(TestCase):
#     learning_parameter = LearningParameter({
#         'include_failed_data': False,
#         'include_tag_vector': False,
#         'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION
#     })
#     bot_id = 1  # テスト用のbot_id いずれの値でも動作する
#
#     def setUp(self):
#         model_path = Persistance.get_model_path(self.bot_id)
#         if os.path.isfile(model_path):
#             os.remove(model_path)
#
#     def test_learn(self):
#         m = mox.Mox()
#         training_message = m.CreateMock(TrainingMessage)
#         training_message.__build_learning_training_messages().AndReturn([[1,2,3],[4,5,6]])
#         # l = Login()  # これから開発するLoginクラス
#         # m.StubOutWithMock(Login, 'get_user_by_id')  # スタブ化
#         # Login.get_user_by_id().AndReturn(user)  # スタブ化した関数の戻り値をセット
#
#         m.ReplayAll()  # mox 始動！
#         # self.assertTrue(l.login())  # ログインテスト！
#         m.VerifyAll()  # mox 結果チェック！
#
#         model_path = Persistance.get_model_path(self.bot_id)
#         # Persistance.dump_vectorizer(training_set.body_array.vectorizer, self.bot_id)
#         Bot(self.bot_id, self.learning_parameter).learn()
#
#         # training_set.xとyをmockする
#         ok_(os.path.exists(model_path))
