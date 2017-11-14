from unittest import TestCase
from nose.tools import ok_
import numpy as np
from tests.support.helper import Helper

from app.shared.constants import Constants
from app.controllers.reply_controller import ReplyController
from app.controllers.learn_controller import LearnController


class CosineSimilarityClassificationTestCase(TestCase):

    def setUp(self):
        Helper.init()

    def test_learn_and_reply(self):
        context = Helper.test_context(bot_id=1, algorithm=Constants.ALGORITHM_SIMILARITY_CLASSIFICATION)

        LearnController(context=context).perform()

        X = np.array(['会社の住所が知りたい'])
        reply = ReplyController(context=context).perform(X[0])

        # 結果が1件以上であること
        ok_(len(reply['results']) > 0)
