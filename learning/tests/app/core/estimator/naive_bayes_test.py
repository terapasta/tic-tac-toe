from unittest import TestCase
from nose.tools import ok_, assert_raises

from app.core.estimator.naive_bayes import NaiveBayes

class DummyPersistence:
    def load(self, dump_key):
        return 'estimator'

class NaiveBayesTestCase(TestCase):
    def test_initialize(self):
        naive_bayes = NaiveBayes(persistence=DummyPersistence())
        ok_(True)
