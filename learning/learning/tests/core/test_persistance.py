from learning.core.persistance import Persistance
from unittest import TestCase
from nose.tools import ok_, eq_

class PersistanceTestCase(TestCase):

    # def setUp(self):
    #     print('before test')
    # def tearDown(self):
    #     print('after test')

    def test_get_model_path(self):
        bot_id = 1
        path = Persistance.get_model_path(bot_id)
        eq_(path, 'learning/models/development/1_estimator')
