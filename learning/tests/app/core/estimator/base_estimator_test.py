from unittest import TestCase
from nose.tools import ok_, assert_raises

from app.core.estimator.base_estimator import BaseEstimator

class ConcreteEstimator(BaseEstimator):
    def __init__(self, persistence=None):
        self.persistence = persistence

    def fit(self, x, y):
        self.x = x
        self.y = y

    def predict(self, question_features):
        self.question_features = question_features

    @property
    def dump_key(self):
        return 'dump_key'


class BaseEstimatorTestCase(TestCase):
    def test_initialize(self):
        estimator = ConcreteEstimator(persistence='hoge')
        ok_(True)
