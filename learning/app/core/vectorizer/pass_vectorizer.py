import numpy as np


class PassVectorizer:
    def __init__(self):
        pass

    def fit(self, sentences):
        pass

    def transform(self, sentences):
        return sentences

    def fit_transform(self, sentences):
        return sentences

    def extract_feature_count(self, sentences):
        return np.count_nonzero(self.transform(sentences))

    @property
    def dump_key(self):
        return self._dump_key
