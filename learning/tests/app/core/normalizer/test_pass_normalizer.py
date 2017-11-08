from unittest import TestCase
from nose.tools import ok_

from app.core.normalizer.pass_normalizer import PassNormalizer

class PassNormalizerTestCase(TestCase):
    def test_initialize(self):
        PassNormalizer()
        ok_(True)