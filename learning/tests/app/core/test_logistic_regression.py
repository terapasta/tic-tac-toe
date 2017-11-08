from unittest import TestCase
from nose.tools import ok_

from app.core.logistic_regression import LogisticRegression

class DummyDatasource:
    def persistence(self):
        pass

class LogisticRegressionTestCase(TestCase):
    def test_initialize(self):
        LogisticRegression(
            datasource=DummyDatasource(),
            estimator='dummy estimator'
        )
        ok_(True)