from unittest import TestCase
import pandas as pd
from nose.tools import ok_

from app.core.tokenizer.mecab_tokenizer import MecabTokenizer
from app.core.vectorizer.tfidf_vectorizer import TfidfVectorizer
from app.core.hybrid_classification import HybridClassification
from app.shared.constants import Constants
from tests.support.helper import Helper


class HybridClassificationTestCase(TestCase):

    def setUp(self):
        Helper.init(bot_id=1, algorithm=Constants.ALGORITHM_WORD2VEC_WMD)
        senteces = MecabTokenizer().tokenize(['田舎のドンキホーテは賑わってる?'])
        self.test_vector = TfidfVectorizer().fit_transform(senteces)

    def test_predict(self):
        estimator = HybridClassification()
        result = estimator.predict(self.test_vector)

        # DataFrameが返ること
        ok_(isinstance(result, pd.DataFrame))
