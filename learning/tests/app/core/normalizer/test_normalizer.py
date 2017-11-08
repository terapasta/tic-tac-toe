from unittest import TestCase
from nose.tools import ok_

from app.core.normalizer.normalizer import Normalizer

class NormalizerTestCase(TestCase):
    def test_initialize(self):
        Normalizer()
        ok_(True)