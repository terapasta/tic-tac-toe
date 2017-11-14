from unittest import TestCase
from nose.tools import assert_raises

from app.shared.constants import Constants
from app.shared.datasource.datasource import Datasource
from app.shared.custom_errors import NotTrainedError
from app.core.tokenizer.mecab_tokenizer import MecabTokenizer
from app.core.vectorizer.tfidf_vectorizer import TfidfVectorizer
from tests.support.helper import Helper
from tests.support.datasource.empty_persistence import EmptyPersistence


class TfidfVectorizerTestCase(TestCase):

    def setUp(self):
        Helper.init(bot_id=1, algorithm=Constants.ALGORITHM_SIMILARITY_CLASSIFICATION)

    def test_predict_when_vocabulary_wasnot_fitted(self):
        datasource = Datasource(persistence=EmptyPersistence)
        vectorizer = TfidfVectorizer(datasource=datasource)

        def action():
            sentences = MecabTokenizer().tokenize(['ピアノ 始める 年齢'])
            vectorizer.transform(sentences)

        # エラーになること
        assert_raises(NotTrainedError, action)
