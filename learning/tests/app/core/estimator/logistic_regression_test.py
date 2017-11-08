from unittest import TestCase
from nose.tools import ok_, assert_raises

from app.core.estimator.logistic_regression import LogisticRegression

class DummyPersistence:
    def load(self, dump_key):
        return 'estimator'

class LogisticRegressionTestCase(TestCase):
    def test_initialize(self):
        logistic_regression = LogisticRegression(persistence=DummyPersistence())
        ok_(True)
