import unittest

from nose.tools import eq_

from learning.core.nlang import Nlang


class TestNlang(unittest.TestCase):

    def test_split_except_conjunction(self):
        result = Nlang.split('明日は雨')
        eq_(result, '明日 雨')

    def test_split_except_adnominal(self):
        result = Nlang.split('あらゆる宝')
        eq_(result, '宝')

    def test_split_except_particle(self):
        result = Nlang.split('明日から明後日')
        eq_(result, '明日 明後日')

    def test_split_except_not_independent_noun(self):
        result = Nlang.split('朝起きること')
        eq_(result, '朝 起きる')

    def test_split_except_not_independent_(self):
        result = Nlang.split('食べちゃう')
        eq_(result, '食べる')

    def test_split_except_aru(self):
        result = Nlang.split('不謹慎である')
        eq_(result, '不謹慎')