from unittest import TestCase
from nose.tools import ok_, eq_
from app.core.preprocessor.word_normalization_preprocessor import WordNormalizationPreprocessor
from tests.support.helper import Helper

class WordNormalizationPreprocessorTestCase(TestCase):
    def test_initialize(self):
        bot = Helper.empty_bot()
        datasource = Helper.empty_datasource()
        synonyms = Helper.test_synonyms()

        # シノニムをセット
        datasource.synonyms = synonyms

        WordNormalizationPreprocessor.new(bot=bot, datasource=datasource)
        ok_(True)

    def test_perform(self):
        bot = Helper.empty_bot()
        datasource = Helper.empty_datasource()
        synonyms = Helper.test_synonyms()

        # シノニムをセット
        datasource.synonyms = synonyms

        wnp = WordNormalizationPreprocessor.new(bot=bot, datasource=datasource)
        testcases = [
            {"arg": "ダッシュ攻撃", "want": "DA"},
            {"arg": "チェックする", "want": "確認する"},
            {"arg": "ダッシュ攻撃をチェック", "want": "DAを確認"},
            {"arg": "ダッシュ攻撃をチェックしたら壊れた", "want": "DAを確認したら調子悪い"},
            {"arg": "プリンター", "want": "プリンター"},
            {"arg": "プリンタ", "want": "プリンター"},
            {"arg": "PC", "want": "PC"},
            {"arg": "パソコン", "want": "PC"},
        ]

        args = [x["arg"] for x in testcases]
        wants = [x["want"] for x in testcases]

        gots = wnp.perform(args)
        for got, want in zip(gots, wants):
            eq_(got, want)

        ok_(True)
