from unittest import TestCase
from nose.tools import ok_
from app.core.estimator.naive_bayes import NaiveBayes
from tests.support.helper import Helper


class NaiveBayesTestCase(TestCase):
    def test_initialize(self):
        NaiveBayes(datasource=Helper.empty_datasource())
        ok_(True)
