from unittest import TestCase
from nose.tools import ok_
from app.core.normalizer.normalizer import Normalizer
from tests.support.helper import Helper


class NormalizerTestCase(TestCase):
    def test_initialize(self):
        Normalizer(datasource=Helper.empty_datasource())
        ok_(True)
