from unittest import TestCase
from nose.tools import ok_
from app.core.reducer.pass_reducer import PassReducer
from tests.support.helper import Helper


class PassReducerTestCase(TestCase):
    def test_initialize(self):
        PassReducer(datasource=Helper.empty_datasource())
        ok_(True)
