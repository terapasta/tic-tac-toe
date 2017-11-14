class BaseNormalizer:
    def init_by_bot(self, bot, key):
        raise NotImplementedError()

    def fit(self, features):
        raise NotImplementedError()

    def transform(self, features):
        raise NotImplementedError()

    def fit_transform(self, features):
        raise NotImplementedError()

    @property
    def dump_key(self, features):
        raise NotImplementedError()
