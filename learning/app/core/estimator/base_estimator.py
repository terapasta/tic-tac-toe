class BaseEstimator:
    def __init__(self, persistence=None):
        raise NotImplementedError()

    def fit(self, x, y):
        raise NotImplementedError()

    def predict(self, question_features):
        raise NotImplementedError()

    @property
    def dump_key(self):
        raise NotImplementedError()
