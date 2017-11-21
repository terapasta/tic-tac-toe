from app.shared.bot import Bot
from app.shared.logger import logger
from app.shared.constants import Constants
from app.factories.cosine_similarity_factory import CosineSimilarityFactory
from app.factories.logistic_regression_factory import LogisticRegressionFactory
from app.factories.two_step_cosine_similarity_factory import TwoStepCosineSimilarityFactory
from app.factories.word2vec_wmd_factory import Word2vecWmdFactory
from app.factories.hybrid_classification_factory import HybridClassificationFactory
from app.shared.base_cls import BaseCls


# Note: リクエストされたコンテキスト情報を保持する
class Context(BaseCls):
    def __init__(self, bot_id, learning_parameter, grpc_context=None):
        self._bot = Bot(bot_id=bot_id, learning_parameter=learning_parameter)
        self._grpc_context = grpc_context

        self._factory_cls = CosineSimilarityFactory
        algorithm = self._bot.algorithm
        if algorithm == Constants.ALGORITHM_SIMILARITY_CLASSIFICATION:
            logger.info('algorithm: Simmilarity Classification')
            self._factory_cls = CosineSimilarityFactory

        if algorithm == Constants.ALGORITHM_TWO_STEP_SIMILARITY_CLASSIFICATION:
            logger.info('algorithm: Two Steps Simmilarity Classification')
            self._factory_cls = TwoStepCosineSimilarityFactory

        if algorithm == Constants.ALGORITHM_WORD2VEC_WMD:
            logger.info('algorithm: Word2vec WMD')
            self._factory_cls = Word2vecWmdFactory

        if algorithm == Constants.ALGORITHM_HYBRID_CLASSIFICATION:
            logger.info('algorithm: Hybrid Classification')
            self._factory_cls = HybridClassificationFactory

        if algorithm == Constants.ALGORITHM_LOGISTIC_REGRESSION:
            logger.info('algorithm: Logistic Regression')
            self._factory_cls = LogisticRegressionFactory

    @property
    def current_bot(self):
        return self._bot

    def get_factory(self):
        return self._factory_cls.new(context=self)
