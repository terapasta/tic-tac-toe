from unittest import TestCase
from nose.tools import ok_

from app.shared.constants import Constants
from tests.support.helper import Helper

from app.core.two_steps_cosine_similarity import TwoStepsCosineSimilarity

class TwoStepsCosineSimilariryTestCase(TestCase):
    def setUp(self):
        Helper.init(bot_id=1, algorithm=Constants.ALGORITHM_WORD2VEC_WMD)

    def test_initialize(self):
        TwoStepsCosineSimilarity()
        ok_(True)