from app.core.reducer.base_reducer import BaseReducer


class PassReducer(BaseReducer):
    def __init__(self):
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
