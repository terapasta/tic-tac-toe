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

    def test_predict(self):
        X = ['Windowsにログイン出来ない']
        reply = Reply(self.BOT_ID, helper.learning_parameter())
        answers = reply.predict(X)

        # 戻り値にlistが返ること
        eq_(answers.__class__, list)
        # answer_idsに1件以上の値が格納されていること
        ok_(len(reply.answer_ids) > 0)
        # probabilitiesに1件以上の値が格納されていること
        ok_(len(reply.probabilities) > 0)
