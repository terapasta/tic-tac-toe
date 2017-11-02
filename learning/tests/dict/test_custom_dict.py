from unittest import TestCase
import MeCab
from nose.tools import ok_, eq_
from app.shared.config import Config


class CustomDictTestCase(TestCase):

    def setUp(self):
        Config().init('test')
        pass

    def test_parse(self):
        tagger = MeCab.Tagger("-u dict/custom.dic -d " + Config().get('dicdir'))
        node = tagger.parseToNode('ねぇほしょうｍｏコムってなに')

        node = node.next
        features = node.feature.split(',')
        eq_(features[0], '感動詞')
        eq_(features[6], 'ねぇ')

        node = node.next
        features = node.feature.split(',')
        eq_(features[0], '名詞')
        eq_(features[6], 'ほしょうｍｏコム')

        ok_(True)
