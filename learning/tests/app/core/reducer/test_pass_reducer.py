from unittest import TestCase
from nose.tools import ok_, assert_raises

from app.core.reducer.pass_reducer import PassReducer

class PassReducerTestCase(TestCase):
    def test_initialize(self):
        PassReducer()
        ok_(True)