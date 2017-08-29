from sklearn.preprocessing import Normalizer as SkNormalizer
from app.shared.current_bot import CurrentBot
from app.shared.loader import Loader


class Normalizer:
    def __init__(self, bot=None, loader=None):
        self.bot = bot if bot is not None else CurrentBot()
        self.loader = loader if loader is not None else Loader()
        self.normalizer = self.loader.load(self.dump_path)

    def fit(self, features):
        self.normalizer = SkNormalizer(copy=False)
        self.normalizer.fit(features)
        self.loader.dump(self.normalizer, self.dump_path)

    def transform(self, features):
        return self.normalizer.transform(features)

    def fit_transform(self, features):
        self.fit(features)
        return self.transform(features)

    @property
    def dump_path(self):
        return self.bot.dump_dirpath + '/normalizer'
