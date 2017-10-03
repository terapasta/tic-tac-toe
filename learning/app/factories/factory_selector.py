from app.shared.current_bot import CurrentBot
from app.shared.logger import logger
from app.shared.constants import Constants
from app.factories.cosine_similarity_with_wiki_corpus_factory import CosineSimilarityWithWikiCorpusFactory
from app.factories.logistic_regression_factory import LogisticRegressionFactory


class FactorySelector:
    def __init__(self, bot=None):
        self.bot = bot if bot is not None else CurrentBot()

    def get_factory(self):
        if self.bot.algorithm == Constants.ALGORITHM_SIMILARITY_CLASSIFICATION:
            logger.info('algorithm: Simmilarity Classification')
            return CosineSimilarityWithWikiCorpusFactory()

        if self.bot.algorithm == Constants.ALGORITHM_LOGISTIC_REGRESSION:
            logger.info('algorithm: Logistic Regression')
            return LogisticRegressionFactory()

        return CosineSimilarityWithWikiCorpusFactory()
