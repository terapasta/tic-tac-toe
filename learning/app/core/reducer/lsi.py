import inject
from sklearn.decomposition import TruncatedSVD
from app.shared.app_status import AppStatus
from app.shared.datasource.datasource import Datasource


class LSI:
    @inject.params(datasource=Datasource, app_status=AppStatus)
    def __init__(self, datasource=None, app_status=None):
        self.bot = app_status.current_bot()
        self.persistence = datasource.persistence
        self.reducer = self.persistence.load(self.dump_key)

    def fit(self, features):
        # NOTE:
        #   n_componentsは削減後の次元数。
        #   条件: n_components must be between 1 and min(A.shape)
        n_components = min(features.shape)
        if n_components > 1:
            n_components = (n_components - 1)
        self.reducer = TruncatedSVD(n_components=n_components, algorithm='randomized', n_iter=10, random_state=42)
        self.reducer.fit(features)
        self.persistence.dump(self.reducer, self.dump_key)

    def transform(self, features):
        return self.reducer.transform(features)

    def fit_transform(self, features):
        self.fit(features)
        return self.transform(features)

    @property
    def dump_key(self):
        return 'sk_lsi'
