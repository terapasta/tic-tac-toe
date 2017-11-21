from unittest import TestCase
from nose.tools import ok_

from app.shared.constants import Constants
from app.controllers.learn_controller import LearnController
from app.controllers.reply_controller import ReplyController
from tests.support.helper import Helper


class Word2vecWmdClassificationTestCase(TestCase):

    def test_reply(self):
        context = Helper.test_context(bot_id=1, algorithm=Constants.ALGORITHM_WORD2VEC_WMD)

        LearnController.new(context=context).perform()
        reply = ReplyController.new(context=context).perform('会社の住所が知りたい')

        # 結果が1件以上であること
        ok_(len(reply['results']) > 0)
