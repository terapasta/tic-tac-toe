class PassReducer:
    def __init__(self):
        pass

    def fit(self, features):
        pass

    def transform(self, features):
        return features

    def fit_transform(self, features):
        self.fit(features)
        return self.transform(features)

    @property
    def dump_path(self):
        return ''
