from unittest import TestCase
from nose.tools import ok_, assert_raises

from app.shared.constants import Constants
from app.core.reducer.lsi import LSI
from tests.support.helper import Helper

class LSITestCase(TestCase):
    def setUp(self):
        Helper.init(bot_id=9, algorithm=Constants.ALGORITHM_SIMILARITY_CLASSIFICATION)

    def test_initialize(self):
        LSI()
        ok_(True)