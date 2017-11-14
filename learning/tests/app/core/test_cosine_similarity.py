from unittest import TestCase
from nose.tools import ok_

from app.core.cosine_similarity import CosineSimilarity
from app.shared.constants import Constants
from app.shared.datasource.datasource import Datasource
from tests.support.datasource.empty_question_answers import EmptyQuestionAnswers
from tests.support.helper import Helper


class CosineSimilarityTestCase(TestCase):

    def setUp(self):
        Helper.init()

    def test_predict_when_data_is_empty(self):
        context = Helper.test_context(bot_id=1, algorithm=Constants.ALGORITHM_SIMILARITY_CLASSIFICATION)
        datasource = Datasource(question_answers=EmptyQuestionAnswers)

        estimator = CosineSimilarity(bot=context.current_bot, datasource=datasource)

        results = estimator.predict([])

        ok_(len(results['question_answer_id']) == 0)
