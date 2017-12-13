from unittest import TestCase
from nose.tools import eq_

from app.shared.constants import Constants
from app.factories.logistic_regression_factory import LogisticRegressionFactory
from app.factories.cosine_similarity_factory import CosineSimilarityFactory
from app.factories.two_step_cosine_similarity_factory import TwoStepCosineSimilarityFactory
from app.factories.word2vec_wmd_factory import Word2vecWmdFactory
from app.factories.hybrid_classification_factory import HybridClassificationFactory

from app.feedback.pass_feedback import PassFeedback
from app.feedback.rocchio_feedback import RocchioFeedback
from app.feedback.nearest_centroid_feedback import NearestCentroidFeedback


from tests.support.helper import Helper


class ContextTestCase(TestCase):

    def test_logistic_regression(self):
        context = Helper.test_context(bot_id=1, algorithm=Constants.ALGORITHM_LOGISTIC_REGRESSION)
        factory = context.get_factory()

        eq_(factory.__class__.__name__, LogisticRegressionFactory.__name__)

    def test_cosine_similarity(self):
        context = Helper.test_context(bot_id=1, algorithm=Constants.ALGORITHM_SIMILARITY_CLASSIFICATION)
        factory = context.get_factory()

        eq_(factory.__class__.__name__, CosineSimilarityFactory.__name__)

    def test_two_steps_cosine_similarity(self):
        context = Helper.test_context(bot_id=1, algorithm=Constants.ALGORITHM_TWO_STEP_SIMILARITY_CLASSIFICATION)
        factory = context.get_factory()

        eq_(factory.__class__.__name__, TwoStepCosineSimilarityFactory.__name__)

    def test_word2vec_wmd(self):
        context = Helper.test_context(bot_id=1, algorithm=Constants.ALGORITHM_WORD2VEC_WMD)
        factory = context.get_factory()

        eq_(factory.__class__.__name__, Word2vecWmdFactory.__name__)

    def test_hybrid_classification(self):
        context = Helper.test_context(bot_id=1, algorithm=Constants.ALGORITHM_HYBRID_CLASSIFICATION)
        factory = context.get_factory()

        eq_(factory.__class__.__name__, HybridClassificationFactory.__name__)

    def test_feedback_none(self):
        context = Helper.test_context(bot_id=1, feedback_algorithm=Constants.FEEDBACK_ALGORITHM_NONE)
        feedback = context.get_feedback()

        eq_(feedback.__class__.__name__, PassFeedback.__name__)

    def test_feedback_rocchio(self):
        context = Helper.test_context(bot_id=1, feedback_algorithm=Constants.FEEDBACK_ALGORITHM_ROCCHIO)
        feedback = context.get_feedback()

        eq_(feedback.__class__.__name__, RocchioFeedback.__name__)

    def test_feedback_nearest_centroid(self):
        context = Helper.test_context(bot_id=1, feedback_algorithm=Constants.FEEDBACK_ALGORITHM_NEAREST_CENTROID)
        feedback = context.get_feedback()

        eq_(feedback.__class__.__name__, NearestCentroidFeedback.__name__)
