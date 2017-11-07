from unittest import TestCase
import inject
from nose.tools import ok_, assert_raises

from sklearn.exceptions import NotFittedError
from app.core.cosine_similarity import CosineSimilarity
from app.shared.config import Config
from app.shared.constants import Constants
from app.shared.app_status import AppStatus
from app.shared.datasource.datasource import Datasource
from tests.support.empty_question_answers import EmptyQuestionAnswers


class LearningParameter:
    algorithm = Constants.ALGORITHM_SIMILARITY_CLASSIFICATION


class CosineSimilarityTestCase(TestCase):

    def setUp(self):
        inject.configure_once()
        Config().init('test')
        Datasource().init(datasource_type=Constants.DATASOURCE_TYPE_FILE)

    def test_predict_when_data_is_empty(self):
        AppStatus().set_bot(bot_id=1, learning_parameter=LearningParameter())
        # データが存在しない場合
        estimator = CosineSimilarity(question_answers=EmptyQuestionAnswers)

        estimator.predict([])

        # エラーにならないこと
        ok_(True)

    def test_predict_when_vocabulary_wasnot_fitted(self):
        AppStatus().set_bot(bot_id=9, learning_parameter=LearningParameter())
        # ボキャブラリーがない場合(未学習の場合)
        estimator = CosineSimilarity()

        def action():
            estimator.predict(['ピアノ 始める 年齢'])

        # エラーになること
        assert_raises(NotFittedError, action)
