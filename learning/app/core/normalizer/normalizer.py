from injector import inject
from sklearn.preprocessing import Normalizer as SkNormalizer
from app.shared.datasource.datasource import Datasource
from app.core.normalizer.base_normalizer import BaseNormalizer


class Normalizer(BaseNormalizer):
    @inject
    def __init__(self, datasource: Datasource, dump_key='sk_normalizer'):
        self.persistence = datasource.persistence
        self._dump_key = dump_key
        self.estimator = None

    def set_persistence(self, persistence, key=None):
        if key is not None:
            self._dump_key = key
        self.persistence = persistence
        return self

    def fit(self, features):
        self._prepare_instance_if_needed()
        self.normalizer.fit(features)
        self.persistence.dump(self.normalizer, self.bot_id, self.dump_key)

    def transform(self, features):
        self._prepare_instance_if_needed()
        return self.normalizer.transform(features)

    def fit_transform(self, features):
        self.fit(features)
        return self.transform(features)

    @property
    def dump_key(self):
        return self._dump_key

    def _prepare_instance_if_needed(self):
        if self.normalizer is None:
            self.normalizer = self.persistence.load(self.dump_key)
        if self.normalizer is None:
            self.normalizer = SkNormalizer(copy=False)
