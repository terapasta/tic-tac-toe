from app.shared.base_cls import BaseCls


class BaseExpander(BaseCls):
    def __init__(self, datasource=None, dump_key=None):
        raise NotImplementedError()

    def fit(self, x, y):
        raise NotImplementedError()

    def predict(self, question_features):
        raise NotImplementedError()

    @property
    def dump_key(self):
        raise NotImplementedError()
