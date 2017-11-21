from unittest import TestCase
from nose.tools import ok_
from app.core.reducer.lsi import LSI
from tests.support.helper import Helper


class LSITestCase(TestCase):
    def test_initialize(self):
        LSI(datasource=Helper.empty_datasource())
        ok_(True)
