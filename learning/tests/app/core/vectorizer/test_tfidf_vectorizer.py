from unittest import TestCase
from nose.tools import assert_raises
from sklearn.exceptions import NotFittedError
from app.shared.datasource.datasource import Datasource
from app.core.tokenizer.mecab_tokenizer import MecabTokenizer
from app.core.vectorizer.tfidf_vectorizer import TfidfVectorizer
from tests.support.datasource.empty_persistence import EmptyPersistence


class TfidfVectorizerTestCase(TestCase):
    def test_predict_when_vocabulary_wasnot_fitted(self):
        datasource = Datasource.new(persistence=EmptyPersistence())
        vectorizer = TfidfVectorizer.new(datasource=datasource)

        def action():
            sentences = MecabTokenizer.new().tokenize(['ピアノ 始める 年齢'])
            vectorizer.transform(sentences)

        # エラーになること
        assert_raises(NotFittedError, action)
