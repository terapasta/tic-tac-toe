from app.shared.current_bot import CurrentBot
from app.shared.logger import logger
from app.shared.constants import Constants
from app.factories.cosine_similarity_factory import CosineSimilarityFactory
from app.factories.logistic_regression_factory import LogisticRegressionFactory
from app.shared.datasource.database.question_answers import QuestionAnswers as QuestionAnswersFromDatabase
from app.shared.datasource.csv.question_answers import QuestionAnswers as QuestionAnswersFromCSV


class FactorySelector:
    def __init__(self, bot=None):
        self.bot = bot if bot is not None else CurrentBot()

    def get_factory(self):
        qas = self._get_qas_data_source()

        if self.bot.algorithm == Constants.ALGORITHM_SIMILARITY_CLASSIFICATION:
            logger.info('algorithm: Simmilarity Classification')
            return CosineSimilarityFactory(question_answers=qas)

        if self.bot.algorithm == Constants.ALGORITHM_LOGISTIC_REGRESSION:
            logger.info('algorithm: Logistic Regression')
            return LogisticRegressionFactory(question_answers=qas)

        return CosineSimilarityFactory()

    def _get_qas_data_source(self):
        qas = None
        if self.bot.datasource_type == Constants.DATASOURCE_TYPE_DATABASE:
            logger.info('datasource: Database')
            qas = QuestionAnswersFromDatabase()
        if self.bot.datasource_type == Constants.DATASOURCE_TYPE_CSV:
            logger.info('datasource: CSV')
            qas = QuestionAnswersFromCSV()

        return qas
