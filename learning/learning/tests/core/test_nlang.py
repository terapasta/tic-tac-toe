# -*- coding: utf-8 -
import random
import unittest
from ...core.nlang import Nlang

class TestNlang(unittest.TestCase):

    def test_split(self):
        result = Nlang.split(u'明日は天気かな？')
        self.assertEqual(result, u'明日 天気')

    def text_split_karamage(self):
        result = Nlang.split(u'人狼は')
        self.assertEqual(result, u'人 狼')

if __name__ == '__main__':
    unittest.main()
