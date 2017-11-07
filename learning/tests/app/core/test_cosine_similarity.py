from unittest import TestCase
from nose.tools import ok_

from app.core.cosine_similarity import CosineSimilarity
from app.shared.constants import Constants
from tests.support.empty_question_answers import EmptyQuestionAnswers

from tests.support.helper import Helper


class CosineSimilarityTestCase(TestCase):

    def setUp(self):
        Helper.init(bot_id=9, algorithm=Constants.ALGORITHM_SIMILARITY_CLASSIFICATION)

    def test_predict_when_data_is_empty(self):
        # データが存在しない場合
        estimator = CosineSimilarity(question_answers=EmptyQuestionAnswers())

        estimator.predict([])

        # エラーにならないこと
        ok_(True)
