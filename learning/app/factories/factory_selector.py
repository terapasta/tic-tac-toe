from app.shared.current_bot import CurrentBot
from app.factories.cosine_similarity_factory import CosineSimilarityFactory


class FactorySelector:
    def __init__(self, bot=None):
        self.bot = bot if bot is not None else CurrentBot()

    def get_factory(self):
        if self.bot.algorithm == 'similarity_classification':
            return CosineSimilarityFactory()

        return CosineSimilarityFactory()
