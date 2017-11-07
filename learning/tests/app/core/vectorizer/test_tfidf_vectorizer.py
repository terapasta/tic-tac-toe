from unittest import TestCase
from nose.tools import assert_raises

from sklearn.exceptions import NotFittedError
from app.shared.constants import Constants
from tests.support.helper import Helper


from app.core.tokenizer.mecab_tokenizer import MecabTokenizer
from app.core.vectorizer.tfidf_vectorizer import TfidfVectorizer
from tests.support.empty_persistence import EmptyPersistence


class TfidfVectorizerTestCase(TestCase):

    def setUp(self):
        Helper.init(bot_id=1, algorithm=Constants.ALGORITHM_SIMILARITY_CLASSIFICATION)

    def test_predict_when_vocabulary_wasnot_fitted(self):
        vectorizer = TfidfVectorizer(persistence=EmptyPersistence())

        def action():
            sentences = MecabTokenizer().tokenize(['ピアノ 始める 年齢'])
            vectorizer.transform(sentences)

        # エラーになること
        assert_raises(NotFittedError, action)
