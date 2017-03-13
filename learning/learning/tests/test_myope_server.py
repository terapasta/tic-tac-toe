from unittest.mock import MagicMock, patch

from learning.core.learn.bot import Bot
from learning.core.learn.learning_parameter import LearningParameter
from unittest import TestCase
from nose.tools import ok_, eq_

from myope_server import MyopeServer


class MyopeServerTestCase(TestCase):

    def setUp(self):
        self.bot_id = 999
        self.learning_parameter_attributes = {
            'include_failed_data': False,
            'include_tag_vector': False,
            'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION
        }

    # def test_reply(self):
    #     ok_(True)

    def test_learn(self):
        m = MagicMock()
        evaluator = MagicMock(
            accuracy = 0.99,
            precision = 0.98,
            recall = 0.97,
            f1 = 0.96
        )
        m.return_value = evaluator
        Bot.learn = m

        myope_server = MyopeServer()
        result = myope_server.learn(self.bot_id, self.learning_parameter_attributes)

        ok_(result['accuracy'] == 0.99)
        ok_(result['precision'] == 0.98)
        ok_(result['recall'] == 0.97)
        ok_(result['f1'] == 0.96)
