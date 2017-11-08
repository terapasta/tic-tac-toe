from unittest import TestCase
from nose.tools import ok_, assert_raises

from app.core.vectorizer.pass_vectorizer import PassVectorizer

class PassVectorizerTestCase(TestCase):
    def test_initialize(self):
        PassVectorizer()
        ok_(True)