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

    def test_split_except_aru(self):
        result = Nlang.split('不謹慎である')
        eq_(result, '不謹慎')




    # 形容動詞を捨てる
    # 非自立名詞を捨てる
    # 非自立動詞を捨てる
