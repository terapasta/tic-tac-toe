from injector import inject
import numpy as np
import scipy.sparse as sp
from sklearn.exceptions import NotFittedError
from sklearn.feature_extraction.text import TfidfVectorizer
from app.shared.datasource.datasource import Datasource
from app.shared.custom_errors import NotTrainedError
from app.core.vectorizer.base_vectorizer import BaseVectorizer


class FuzzyTermVectorizer(BaseVectorizer):
    @inject
    def __init__(self, datasource: Datasource, dump_key='fuzzy_term_vectorizer'):
        self.persistence = datasource.persistence
        self._dump_key = dump_key
        self.vectorizer = None

    def fit(self, sentences):
        self._prepare_instance_if_needed()
        self.vectorizer.fit(sentences)
        self.persistence.dump(self.vectorizer, self.dump_key)

    def transform(self, sentences):
        self._prepare_instance_if_needed()
        try:
            fv = self.vectorizer.transform(sentences)
            return fv
        except NotFittedError as e:
            raise NotTrainedError(e)

    def fit_transform(self, sentences):
        self.fit(sentences)
        return self.transform(sentences)

    def extract_feature_count(self, sentences):
        return np.count_nonzero(self.transform(sentences).toarray())

    @property
    def dump_key(self):
        return self._dump_key

    def _prepare_instance_if_needed(self):
        # 学習済みのベクタライザがあればそれをロード
        if self.vectorizer is None:
            self.vectorizer = self.persistence.load(self.dump_key)

        # 学習済みのものがなければ新規作成
        if self.vectorizer is None:
            self.vectorizer = TfidfVectorizer(use_idf=True, token_pattern=u'(?u)\\b\\w+\\b')
