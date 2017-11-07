from unittest import TestCase
import pandas as pd
from nose.tools import ok_

from app.core.tokenizer.mecab_tokenizer import MecabTokenizer
from app.core.vectorizer.tfidf_vectorizer import TfidfVectorizer
from app.core.hybrid_classification import HybridClassification
from app.shared.constants import Constants
from app.shared.datasource.datasource import Datasource
from tests.support.helper import Helper
from tests.support.datasource.empty_question_answers import EmptyQuestionAnswers


class HybridClassificationTestCase(TestCase):

    def setUp(self):
        Helper.init(bot_id=1, algorithm=Constants.ALGORITHM_WORD2VEC_WMD)
        senteces = MecabTokenizer().tokenize(['田舎のドンキホーテは賑わってる?'])
        self.vectorizer = TfidfVectorizer()
        self.test_vector = self.vectorizer.fit_transform(senteces)

    def test_predict(self):
        # Note: ボキャブラリを保有しているvectorizerを使う
        estimator = HybridClassification(vectorizer=self.vectorizer)
        result = estimator.predict(self.test_vector)

        # DataFrameが返ること
        ok_(isinstance(result, pd.DataFrame))

    def test_predict_when_data_is_empty(self):
        # データが存在しない場合
        datasource = Datasource(question_answers=EmptyQuestionAnswers)
        estimator = HybridClassification(datasource=datasource)
        estimator.predict([])

        # エラーにならないこと
        ok_(True)
