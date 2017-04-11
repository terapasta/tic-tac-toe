from unittest import TestCase
from nose.tools import ok_, eq_

from learning.core.learn.bot import Bot
from learning.core.predict.reply import Reply
from learning.tests import helper

class ReplyTestCase(TestCase):
    BOT_ID = 10001  # engineのテストと重複しないIDを指定

    @classmethod
    def setUpClass(cls):
        _ = Bot(cls.BOT_ID, helper.learning_parameter())\
            .learn(csv_file_path='learning/tests/fixtures/default.csv')

    def test_perform(self):
        X = ['Windowsにログイン出来ない']
        reply = Reply(self.BOT_ID, helper.learning_parameter())
        reply_result = reply.perform(X)

        # answer_idにいずれかのidがセットされていること
        ok_(reply_result.answer_id != 0)
        # probabilityが0より大きいこと
        ok_(reply_result.probability > 0)
