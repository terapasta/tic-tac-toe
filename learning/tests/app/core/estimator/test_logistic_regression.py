from unittest import TestCase
from nose.tools import ok_
from app.core.estimator.logistic_regression import LogisticRegression
from tests.support.helper import Helper


class LogisticRegressionTestCase(TestCase):
    def test_initialize(self):
        LogisticRegression(datasource=Helper.empty_datasource())
        ok_(True)
