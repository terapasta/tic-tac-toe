from app.shared.bot import Bot
from app.shared.logger import logger
from app.shared.constants import Constants
from app.shared.datasource.datasource import Datasource
from app.shared.base_cls import BaseCls

from app.factories.cosine_similarity_factory import CosineSimilarityFactory
from app.factories.topic_cosine_similarity_factory import TopicCosineSimilarityFactory
from app.factories.fuzzy_cosine_similarity_factory import FuzzyCosineSimilarityFactory
from app.factories.strict_fuzzy_cosine_similarity_factory import StrictFuzzyCosineSimilarityFactory
from app.factories.logistic_regression_factory import LogisticRegressionFactory
from app.factories.two_step_cosine_similarity_factory import TwoStepCosineSimilarityFactory
from app.factories.hybrid_classification_factory import HybridClassificationFactory

from app.feedback.rocchio_feedback import RocchioFeedback
from app.feedback.nearest_centroid_feedback import NearestCentroidFeedback
from app.feedback.pass_feedback import PassFeedback


# Note: リクエストされたコンテキスト情報を保持する
class Context(BaseCls):
    def __init__(self, bot_id, learning_parameter, grpc_context=None, datasource: Datasource=None, phase=Constants.PHASE_REPLYING):
        self._bot = Bot(bot_id=bot_id, learning_parameter=learning_parameter)
        self._grpc_context = grpc_context
        self._datasource = datasource if datasource is not None else Datasource.new()
        self._datasource.persistence.init_by_bot(self.current_bot)
        self._pass_feedback = False
        self._phase = phase

    @property
    def current_bot(self):
        return self._bot

    @property
    def pass_feedback(self):
        return self._pass_feedback

    @property
    def phase(self):
        return self._phase

    @phase.setter
    def phase(self, phase):
        self._phase = phase

    def get_datasource(self):
        return self._datasource

    def get_factory(self):
        factory_cls = CosineSimilarityFactory
        algorithm = int(self.current_bot.algorithm)  # pythonコマンドから直接実行した場合にstring型になってしまうためintに変換している
        if algorithm == Constants.ALGORITHM_SIMILARITY_CLASSIFICATION:
            logger.info('algorithm: Simmilarity Classification')
            factory_cls = CosineSimilarityFactory

        elif algorithm == Constants.ALGORITHM_TOPIC_SIMILARITY_CLASSIFICATION:
            logger.info('algorithm: Topic Simmilarity Classification')
            factory_cls = TopicCosineSimilarityFactory

        elif algorithm == Constants.ALGORITHM_TWO_STEP_SIMILARITY_CLASSIFICATION:
            logger.info('algorithm: Two Steps Simmilarity Classification')
            factory_cls = TwoStepCosineSimilarityFactory

        elif algorithm == Constants.ALGORITHM_HYBRID_CLASSIFICATION:
            logger.info('algorithm: Hybrid Classification')
            factory_cls = HybridClassificationFactory

        elif algorithm == Constants.ALGORITHM_LOGISTIC_REGRESSION:
            logger.info('algorithm: Logistic Regression')
            factory_cls = LogisticRegressionFactory
        elif algorithm == Constants.ALGORITHM_FUZZY_COSINE_SIMILARITY_CLASSIFICATION:
            logger.info('algorithm: Fuzzy Cosine Similarity Classification')
            factory_cls = FuzzyCosineSimilarityFactory
        elif algorithm == Constants.ALGORITHM_STRICT_FUZZY_COSINE_SIMILARITY_CLASSIFICATION:
            logger.info('algorithm: Strict Fuzzy Cosine Similarity Classification')
            factory_cls = StrictFuzzyCosineSimilarityFactory

        else:
            logger.info('algorithm: Default')

        factory = factory_cls.new(
            bot=self.current_bot,
            datasource=self.get_datasource(),
            feedback=self.get_feedback(),
        )

        # set_phaseメソッドが定義されている場合、phase をセットする
        # see: https://docs.python.org/3.6/library/functions.html#getattr
        #      https://docs.python.org/3.6/library/functions.html#callable
        op = getattr(factory, "set_phase", None)
        if callable(op):
            factory.set_phase(self.phase)

        return factory

    def get_feedback(self):
        feedback_cls = PassFeedback
        algorithm = self.current_bot.feedback_algorithm
        if algorithm == Constants.FEEDBACK_ALGORITHM_NONE:
            logger.info('feedback algorithm: None')
            self._pass_feedback = True
        elif algorithm == Constants.FEEDBACK_ALGORITHM_NEAREST_CENTROID:
            logger.info('feedback algorithm: Rocchio (use NearestCentroid)')
            feedback_cls = NearestCentroidFeedback
        else:
            logger.info('feedback algorithm: Rocchio')
            feedback_cls = RocchioFeedback

        return feedback_cls.new(
            bot=self.current_bot,
            datasource=self._datasource,
        )
