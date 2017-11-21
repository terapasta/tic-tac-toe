from unittest import TestCase
from nose.tools import ok_

from app.core.logistic_regression import LogisticRegression
from app.shared.constants import Constants
from tests.support.helper import Helper


class LogisticRegressionTestCase(TestCase):
    def test_initialize(self):
        context = Helper.test_context(bot_id=1, algorithm=Constants.ALGORITHM_LOGISTIC_REGRESSION)
        LogisticRegression.new(
            bot=context.current_bot,
            estimator='dummy estimator'
        )
        ok_(True)
