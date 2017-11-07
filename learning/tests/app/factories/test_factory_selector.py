from unittest import TestCase
from nose.tools import eq_

from app.shared.constants import Constants
from app.factories.factory_selector import FactorySelector
from app.factories.logistic_regression_factory import LogisticRegressionFactory
from app.factories.cosine_similarity_factory import CosineSimilarityFactory
from app.factories.two_step_cosine_similarity_factory import TwoStepCosineSimilarityFactory
from app.factories.word2vec_wmd_factory import Word2vecWmdFactory
from app.shared.datasource.datasource import Datasource


from tests.support.helper import Helper


class FactorySelectorTestCase(TestCase):

    def setUp(self):
        Datasource().init(datasource_type=Constants.DATASOURCE_TYPE_FILE)

    def test_logistic_regression(self):
        Helper.init(bot_id=1, algorithm=Constants.ALGORITHM_LOGISTIC_REGRESSION)
        factory = FactorySelector().get_factory()

        eq_(factory.__class__.__name__, LogisticRegressionFactory.__name__)

    def test_cosine_similarity(self):
        Helper.init(bot_id=1, algorithm=Constants.ALGORITHM_SIMILARITY_CLASSIFICATION)
        factory = FactorySelector().get_factory()

        eq_(factory.__class__.__name__, CosineSimilarityFactory.__name__)

    def test_two_steps_cosine_similarity(self):
        Helper.init(bot_id=1, algorithm=Constants.ALGORITHM_TWO_STEP_SIMILARITY_CLASSIFICATION)
        factory = FactorySelector().get_factory()

        eq_(factory.__class__.__name__, TwoStepCosineSimilarityFactory.__name__)

    def test_word2vec_wmd(self):
        Helper.init(bot_id=1, algorithm=Constants.ALGORITHM_WORD2VEC_WMD)
        factory = FactorySelector().get_factory()

        eq_(factory.__class__.__name__, Word2vecWmdFactory.__name__)
