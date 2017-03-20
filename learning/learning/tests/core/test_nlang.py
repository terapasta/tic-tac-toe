import unittest

from learning.core.nlang import Nlang


class TestNlang(unittest.TestCase):

    def test_split(self):
        result = Nlang.split('明日は天気かな？')
        self.assertEqual(result, '明日 天気')

    def text_split_karamage(self):
        result = Nlang.split('人狼は')
        self.assertEqual(result, '人 狼')

    # 接続詞を捨てる
    # 連体詞を捨てる
    # 助詞を捨てる
    # 代名詞を捨てる
    # 形容動詞を捨てる
    # 非自立名詞を捨てる
    # 非自立動詞を捨てる
    # あるを捨てる
