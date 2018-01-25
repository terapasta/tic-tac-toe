from injector import inject
import numpy as np
from sklearn.exceptions import NotFittedError
from sklearn.feature_extraction.text import TfidfVectorizer as SkTfidfVectorizer
from app.shared.datasource.datasource import Datasource
from app.shared.custom_errors import NotTrainedError
from app.core.vectorizer.base_vectorizer import BaseVectorizer


class TopicTfidfVectorizer(BaseVectorizer):
    @inject
    def __init__(self, datasource: Datasource, dump_key='topic_tfidf_vectorizer'):
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
            return self.vectorizer.transform(sentences)
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
        if self.vectorizer is None:
            self.vectorizer = self.persistence.load(self.dump_key)
        if self.vectorizer is None:
            # Note: token_patternは1文字のデータを除外しない設定
            self.vectorizer = SkTfidfVectorizer(use_idf=True, token_pattern=u'(?u)\\b\\w+\\b')
