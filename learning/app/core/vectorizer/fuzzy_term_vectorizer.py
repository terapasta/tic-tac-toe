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
        self._prepare_instance_if_needed()

    def fit(self, sentences):
        self.vectorizer.fit(sentences)
        self.persistence.dump(self.vectorizer, self.dump_key)

    def transform(self, sentences):
        return self.vectorizer.transform(sentences)

    def fit_transform(self, sentences):
        self.fit(sentences)
        return self.transform(sentences)

    def extract_feature_count(self, sentences):
        return np.count_nonzero(self.transform(sentences).toarray())

    @property
    def dump_key(self):
        return self._dump_key

    def _create_instance_if_needed(self):
        # 学習済みのものがなければ新規作成
        if self.vectorizer is None:
            self.vectorizer = TfidfVectorizer(use_idf=True, token_pattern=u'(?u)\\b\\w+\\b')
        return self.vectorizer is not None

    def _load_instance_if_needed(self, retry=5, dt=.2):
        # 学習済みのベクタライザがあればそれをロード
        if self.vectorizer is None:
            self.vectorizer = self.persistence.load_with_retry(self.dump_key, retry=retry, dt=dt)
        return self.vectorizer is not None

    def _prepare_instance_if_needed(self):
        return self._load_instance_if_needed(retry=3, dt=.1) or self._create_instance_if_needed()
