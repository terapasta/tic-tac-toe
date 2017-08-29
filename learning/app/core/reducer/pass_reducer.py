class PassReducer:
    def __init__(self):
        pass

    def fit(self, features):
        pass

    def transform(self, features):
        return features.toarray()

    def fit_transform(self, features):
        return features.toarray()

    @property
    def dump_path(self):
        return ''
