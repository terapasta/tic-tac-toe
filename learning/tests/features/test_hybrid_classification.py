from unittest import TestCase
from nose.tools import ok_
import numpy as np

from app.shared.constants import Constants
from app.controllers.reply_controller import ReplyController
from app.controllers.learn_controller import LearnController
from app.factories.hybrid_classification_factory import HybridClassificationFactory
from tests.support.helper import Helper


class HybridClassificationTestCase(TestCase):

    def setUp(self):
        Helper.init(bot_id=1, algorithm=Constants.ALGORITHM_SIMILARITY_CLASSIFICATION)

    def test_learn_and_reply(self):
        factory = HybridClassificationFactory()

        LearnController(factory=factory).perform()

        X = np.array(['会社の住所が知りたい'])
        ReplyController(factory=factory).perform(X[0])

        ok_(True)
