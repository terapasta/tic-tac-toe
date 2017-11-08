import inject
from sklearn.preprocessing import Normalizer as SkNormalizer
from app.shared.app_status import AppStatus
from app.shared.datasource.datasource import Datasource
from app.core.normalizer.base_normalizer import BaseNormalizer


class Normalizer(BaseNormalizer):
    @inject.params(datasource=Datasource, app_status=AppStatus)
    def __init__(self, datasource=None, app_status=None):
        self.bot = app_status.current_bot()
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
        return 'sk_normalizer'
