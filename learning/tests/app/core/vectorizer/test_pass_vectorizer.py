from unittest import TestCase
from nose.tools import ok_
from app.core.vectorizer.pass_vectorizer import PassVectorizer
from tests.support.helper import Helper


class PassVectorizerTestCase(TestCase):
    def test_initialize(self):
        PassVectorizer(datasource=Helper.empty_datasource())
        ok_(True)
