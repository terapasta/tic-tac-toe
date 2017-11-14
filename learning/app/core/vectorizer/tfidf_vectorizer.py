import inject
import numpy as np
from sklearn.exceptions import NotFittedError
from sklearn.feature_extraction.text import TfidfVectorizer as SkTfidfVectorizer
from app.shared.app_status import AppStatus
from app.shared.datasource.datasource import Datasource
from app.shared.custom_errors import NotTrainedError
from app.core.vectorizer.base_vectorizer import BaseVectorizer


class TfidfVectorizer(BaseVectorizer):
    @inject.params(datasource=Datasource, app_status=AppStatus)
    def __init__(self, datasource=None, dump_key='sk_tfidf_vectorizer', app_status=None):
        self.bot = app_status.current_bot()
        self.persistence = datasource.persistence
        self._dump_key = dump_key
        self.vectorizer = self.persistence.load(self.dump_key)
        if self.vectorizer is None:
            # Note: token_patternは1文字のデータを除外しない設定
            self.vectorizer = SkTfidfVectorizer(use_idf=True, token_pattern=u'(?u)\\b\\w+\\b')

    def fit(self, sentences):
        self.vectorizer.fit(sentences)
        self.persistence.dump(self.vectorizer, self.dump_key)

    def transform(self, sentences):
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
