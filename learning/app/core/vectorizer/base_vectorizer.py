class BaseVectorizer:
    def set_persistence(self, persistence, key):
        raise NotImplementedError()

    def fit(self, sentences):
        raise NotImplementedError()

    def transform(self, sentences):
        raise NotImplementedError()

    def fit_transform(self, sentences):
        raise NotImplementedError()

    def extract_feature_count(self, sentences):
        raise NotImplementedError()

    @property
    def dump_key(self):
        raise NotImplementedError()
