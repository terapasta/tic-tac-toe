# -*- coding: utf-8 -
import random
import unittest
from ...core.nlang import Nlang

class TestNlang(unittest.TestCase):

    def test_split(self):
        result = Nlang.split('明日は天気かな？')
        self.assertEqual(result, u'明日 天気')

if __name__ == '__main__':
    unittest.main()
