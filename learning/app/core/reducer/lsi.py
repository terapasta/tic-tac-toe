from injector import inject
from sklearn.decomposition import TruncatedSVD
from app.shared.datasource.datasource import Datasource
from app.core.reducer.base_reducer import BaseReducer


class LSI(BaseReducer):
    @inject
    def __init__(self, datasource: Datasource, dump_key='sk_lsi'):
        self.persistence = datasource.persistence
        self._dump_key = dump_key
        self.estimator = None

    def fit(self, features):
        # NOTE:
        #   n_componentsは削減後の次元数。
        #   条件: n_components must be between 1 and min(A.shape)
        n_components = min(features.shape)
        if n_components > 1:
            n_components = (n_components - 1)
        self.reducer = TruncatedSVD(n_components=n_components, algorithm='randomized', n_iter=10, random_state=42)
        self.reducer.fit(features)
        self.persistence.dump(self.reducer, self.bot_id, self.dump_key)

    def transform(self, features):
        self._prepare_instance_if_needed()
        return self.reducer.transform(features)

    def fit_transform(self, features):
        self.fit(features)
        return self.transform(features)

    @property
    def dump_key(self):
        return 'sk_lsi'

    def _prepare_instance_if_needed(self):
        if self.reducer is None:
            self.reducer = self.persistence.load(self.dump_key)
