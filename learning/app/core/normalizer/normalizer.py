import inject
from sklearn.preprocessing import Normalizer as SkNormalizer
from app.shared.current_bot import CurrentBot
from app.shared.loader import Loader


class Normalizer:
    @inject.params(bot=CurrentBot, loader=Loader)
    def __init__(self, bot=None, loader=None):
        self.bot = bot
        self.loader = loader
        self.normalizer = self.loader.load(self.dump_key)

    def fit(self, features):
        self.normalizer = SkNormalizer(copy=False)
        self.normalizer.fit(features)
        self.loader.dump(self.normalizer, self.dump_key)

    def transform(self, features):
        return self.normalizer.transform(features)

    def fit_transform(self, features):
        self.fit(features)
        return self.transform(features)

    @property
    def dump_key(self):
        return 'dump_normalizer'
