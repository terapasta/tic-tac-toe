from app.core.normalizer.base_normalizer import BaseNormalizer


class PassNormalizer(BaseNormalizer):
    def __init__(self, datasource=None, dump_key=None):
        pass

    def set_persistence(self, persistence, key=None):
        return self

    def fit(self, features):
        pass

    def transform(self, features):
        return features

    def fit_transform(self, features):
        return features

    @property
    def dump_path(self):
        return ''
