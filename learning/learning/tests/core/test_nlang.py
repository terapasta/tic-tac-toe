import unittest

from nose.tools import eq_

from learning.core.nlang import Nlang


class TestNlang(unittest.TestCase):

    def test_split_except_conjunction(self):
        result = Nlang.split('明日は雨')
        eq_(result, '明日 雨')

    # def text_split_karamage(self):
    #     result = Nlang.split('人狼は')
    #     self.assertEqual(result, '人 狼')

    # 連体詞を捨てる
    # 助詞を捨てる
    # 代名詞を捨てる
    # 形容動詞を捨てる
    # 非自立名詞を捨てる
    # 非自立動詞を捨てる
    # あるを捨てる
