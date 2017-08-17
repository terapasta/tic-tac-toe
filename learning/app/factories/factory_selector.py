from app.shared.current_bot import CurrentBot
from app.shared.constants import Constants
from app.factories.cosine_similarity_factory import CosineSimilarityFactory
from app.factories.logistic_regression_factory import LogisticRegressionFactory


class FactorySelector:
    def __init__(self, bot=None):
        self.bot = bot if bot is not None else CurrentBot()

    def get_factory(self):
        if self.bot.algorithm == Constants.ALGORITHM_SIMILARITY_CLASSIFICATION:
            return CosineSimilarityFactory()

        if self.bot.algorithm == Constants.ALGORITHM_LOGISTIC_REGRESSION:
            return LogisticRegressionFactory()

        return CosineSimilarityFactory()
