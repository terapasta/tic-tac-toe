from app.shared.base_cls import BaseCls


class BaseReducer(BaseCls):
    def __init__(self, datasource=None, dump_key=None):
        raise NotImplementedError()

    def set_persistence(self, persistence, key):
        raise NotImplementedError()

    def fit(self, features):
        raise NotImplementedError()

    def transform(self, features):
        raise NotImplementedError()

    def fit_transform(self, features):
        raise NotImplementedError()

    @property
    def dump_path(self):
        raise NotImplementedError()
