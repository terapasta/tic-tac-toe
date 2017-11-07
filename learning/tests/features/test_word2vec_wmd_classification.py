from unittest import TestCase
from nose.tools import ok_, eq_
import numpy as np

from app.factories.word2vec_wmd_factory import Word2vecWmdFactory
from app.shared.constants import Constants
from app.controllers.reply_controller import ReplyController
from app.factories.factory_selector import FactorySelector
from tests.support.helper import Helper


class Word2vecWmdClassificationTestCase(TestCase):

    def setUp(self):
        Helper.init(bot_id=1, algorithm=Constants.ALGORITHM_WORD2VEC_WMD)

    def test_reply(self):
        factory = FactorySelector().get_factory()

        eq_(factory.__class__.__name__, Word2vecWmdFactory.__name__)

        X = np.array(['会社の住所が知りたい'])
        ReplyController(factory=factory).perform(X[0])

        ok_(True)
