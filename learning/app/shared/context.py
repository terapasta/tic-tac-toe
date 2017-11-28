from app.shared.bot import Bot
from app.shared.logger import logger
from app.shared.constants import Constants
from app.shared.datasource.datasource import Datasource
from app.shared.base_cls import BaseCls

from app.factories.cosine_similarity_factory import CosineSimilarityFactory
from app.factories.logistic_regression_factory import LogisticRegressionFactory
from app.factories.two_step_cosine_similarity_factory import TwoStepCosineSimilarityFactory
from app.factories.word2vec_wmd_factory import Word2vecWmdFactory
from app.factories.hybrid_classification_factory import HybridClassificationFactory

from app.core.estimator.rocchio import Rocchio as RocchioEstimator
from app.feedback.rocchio import Rocchio
from app.feedback.pass_feedback import PassFeedback


# Note: リクエストされたコンテキスト情報を保持する
class Context(BaseCls):
    def __init__(self, bot_id, learning_parameter, grpc_context=None, datasource: Datasource=None):
        self._bot = Bot(bot_id=bot_id, learning_parameter=learning_parameter)
        self._grpc_context = grpc_context
        self._datasource = datasource if datasource is not None else Datasource.new()
        self._datasource.persistence.init_by_bot(self.current_bot)

    @property
    def current_bot(self):
        return self._bot

    def get_datasource(self):
        return self._datasource

    def get_factory(self):
        factory_cls = CosineSimilarityFactory
        algorithm = self.current_bot.algorithm
        if algorithm == Constants.ALGORITHM_SIMILARITY_CLASSIFICATION:
            logger.info('algorithm: Simmilarity Classification')
            factory_cls = CosineSimilarityFactory

        if algorithm == Constants.ALGORITHM_TWO_STEP_SIMILARITY_CLASSIFICATION:
            logger.info('algorithm: Two Steps Simmilarity Classification')
            factory_cls = TwoStepCosineSimilarityFactory

        if algorithm == Constants.ALGORITHM_WORD2VEC_WMD:
            logger.info('algorithm: Word2vec WMD')
            factory_cls = Word2vecWmdFactory

        if algorithm == Constants.ALGORITHM_HYBRID_CLASSIFICATION:
            logger.info('algorithm: Hybrid Classification')
            factory_cls = HybridClassificationFactory

        if algorithm == Constants.ALGORITHM_LOGISTIC_REGRESSION:
            logger.info('algorithm: Logistic Regression')
            factory_cls = LogisticRegressionFactory

        return factory_cls.new(
            bot=self.current_bot,
            datasource=self.get_datasource(),
            feedback=self.get_feedback()
        )

    def get_feedback(self):
        feedback = PassFeedback.new()
        algorithm = self.current_bot.algorithm_for_feedback
        if algorithm == Constants.FEEDBACK_ALGORITHM_ROCCHIO:
            feedback = Rocchio.new(
                estimator_for_good=RocchioEstimator.new(datasource=self._datasource, dump_key='sk_rocchio_good'),
                estimator_for_bad=RocchioEstimator.new(datasource=self._datasource, dump_key='sk_rocchio_bad'),
                datasource=self._datasource,
            )
        return feedback
