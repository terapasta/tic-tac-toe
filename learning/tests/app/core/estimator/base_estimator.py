from unittest import TestCase
from nose.tools import ok_, assert_raises

from app.core.estimator.base_estimator import BaseEstimator

class IncompleteEstimator(BaseEstimator):
    pass

class BaseEstimatorTestCase(TestCase):
    def test_initialize(self):
        def init_estimator():
            instance = IncompleteEstimator()
        assert_raises(TypeError, init_estimator)
