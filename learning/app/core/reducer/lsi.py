from sklearn.decomposition import TruncatedSVD
from app.shared.current_bot import CurrentBot
from app.shared.loader import Loader


class LSI:
    def __init__(self, bot=None, loader=None):
        self.bot = bot if bot is not None else CurrentBot()
        self.loader = loader if loader is not None else Loader()
        self.reducer = self.loader.load(self.dump_path)

    def fit(self, features):
        # NOTE:
        #   n_componentsは削減後の次元数。
        #   条件: n_components must be between 1 and min(A.shape)
        n_components = min(features.shape)
        if n_components > 1:
            n_components = (n_components - 1)
        self.reducer = TruncatedSVD(n_components=n_components, algorithm='randomized', n_iter=10, random_state=42)
        self.reducer.fit(features)
        self.loader.dump(self.reducer, self.dump_path)

    def transform(self, features):
        return self.reducer.transform(features)

    def fit_transform(self, features):
        self.fit(features)
        return self.transform(features)

    @property
    def dump_path(self):
        return self.bot.dump_dirpath + '/lsa'
