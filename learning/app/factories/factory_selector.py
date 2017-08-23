from app.shared.current_bot import CurrentBot
from app.shared.logger import logger
from app.shared.constants import Constants
from app.factories.cosine_similarity_factory import CosineSimilarityFactory
from app.factories.logistic_regression_factory import LogisticRegressionFactory
from app.shared.datasource.database.learning_training_messages import LearningTrainingMessages as LearningTrainingMessagesFromDatabase
from app.shared.datasource.csv.learning_training_messages import LearningTrainingMessages as LearningTrainingMessagesFromCSV


class FactorySelector:
    def __init__(self, bot=None):
        self.bot = bot if bot is not None else CurrentBot()

    def get_factory(self):
        ltm = self._get_ltm_data_source()

        if self.bot.algorithm == Constants.ALGORITHM_SIMILARITY_CLASSIFICATION:
            logger.info('algorithm: Simmilarity Classification')
            return CosineSimilarityFactory(ltm=ltm)

        if self.bot.algorithm == Constants.ALGORITHM_LOGISTIC_REGRESSION:
            logger.info('algorithm: Logistic Regression')
            return LogisticRegressionFactory(ltm=ltm)

        return CosineSimilarityFactory()

    def _get_ltm_data_source(self):
        ltm = None
        if self.bot.datasource_type == Constants.DATASOURCE_TYPE_DATABASE:
            logger.info('datasource: Database')
            ltm = LearningTrainingMessagesFromDatabase()
        if self.bot.datasource_type == Constants.DATASOURCE_TYPE_CSV:
            logger.info('datasource: CSV')
            ltm = LearningTrainingMessagesFromCSV()

        return ltm
