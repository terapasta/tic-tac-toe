import inject
from app.shared.app_status import AppStatus
from app.shared.logger import logger
from app.shared.constants import Constants
from app.factories.cosine_similarity_factory import CosineSimilarityFactory
from app.factories.logistic_regression_factory import LogisticRegressionFactory
from app.factories.two_step_cosine_similarity_factory import TwoStepCosineSimilarityFactory
from app.factories.word2vec_wmd_factory import Word2vecWmdFactory


class FactorySelector:
    @inject.params(app_status=AppStatus)
    def __init__(self, app_status=None):
        self.bot = app_status.current_bot()

    def get_factory(self):
        if self.bot.algorithm == Constants.ALGORITHM_SIMILARITY_CLASSIFICATION:
            logger.info('algorithm: Simmilarity Classification')
            return CosineSimilarityFactory()

        if self.bot.algorithm == Constants.ALGORITHM_TWO_STEP_SIMILARITY_CLASSIFICATION:
            logger.info('algorithm: Two Steps Simmilarity Classification')
            return TwoStepCosineSimilarityFactory()

        if self.bot.algorithm == Constants.ALGORITHM_WORD2VEC_WMD:
            logger.info('algorithm: Word2vec WMD')
            return Word2vecWmdFactory()

        if self.bot.algorithm == Constants.ALGORITHM_LOGISTIC_REGRESSION:
            logger.info('algorithm: Logistic Regression')
            return LogisticRegressionFactory()

        return CosineSimilarityWithWikiCorpusFactory()
