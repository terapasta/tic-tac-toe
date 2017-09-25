import inject
from sklearn.preprocessing import Normalizer as SkNormalizer
from app.shared.current_bot import CurrentBot
from app.shared.datasource.datasource import Datasource


class Normalizer:
    @inject.params(bot=CurrentBot, datasource=Datasource)
    def __init__(self, bot=None, datasource=None):
        self.bot = bot
        self.persistence = datasource.persistence
        self.normalizer = self.persistence.load(self.dump_key)

    def fit(self, features):
        self.normalizer = SkNormalizer(copy=False)
        self.normalizer.fit(features)
        self.persistence.dump(self.normalizer, self.dump_key)

    def transform(self, features):
        return self.normalizer.transform(features)

    def fit_transform(self, features):
        self.fit(features)
        return self.transform(features)

    @property
    def dump_key(self):
        return 'dump_normalizer'
