from unittest import TestCase
from nose.tools import ok_

from app.core.cosine_similarity import CosineSimilarity
from app.shared.constants import Constants
from app.shared.datasource.datasource import Datasource
from tests.support.datasource.empty_question_answers import EmptyQuestionAnswers
from tests.support.helper import Helper


class CosineSimilarityTestCase(TestCase):

    def setUp(self):
        Helper.init(bot_id=9, algorithm=Constants.ALGORITHM_SIMILARITY_CLASSIFICATION)

    def test_predict_when_data_is_empty(self):
        datasource = Datasource(question_answers=EmptyQuestionAnswers)

        # データが存在しない場合
        estimator = CosineSimilarity(datasource=datasource)

        estimator.predict([])

        # エラーにならないこと
        ok_(True)
