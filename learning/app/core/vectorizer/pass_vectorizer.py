import numpy as np
from app.core.vectorizer.base_vectorizer import BaseVectorizer


class PassVectorizer(BaseVectorizer):
    def __init__(self, datasource=None, dump_key=''):
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
        return ''
