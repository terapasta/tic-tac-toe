from unittest import TestCase
from nose.tools import ok_
from app.core.normalizer.pass_normalizer import PassNormalizer
from tests.support.helper import Helper


class PassNormalizerTestCase(TestCase):
    def test_initialize(self):
        PassNormalizer.new(datasource=Helper.empty_datasource())
        ok_(True)
