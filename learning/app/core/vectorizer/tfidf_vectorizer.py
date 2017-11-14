import inject
import numpy as np
from sklearn.exceptions import NotFittedError
from sklearn.feature_extraction.text import TfidfVectorizer as SkTfidfVectorizer
from app.shared.datasource.datasource import Datasource
from app.shared.custom_errors import NotTrainedError
from app.core.vectorizer.base_vectorizer import BaseVectorizer


class TfidfVectorizer(BaseVectorizer):
    @inject.params(datasource=Datasource)
    def __init__(self, datasource=None):
        self.persistence = datasource.persistence

    def init_by_bot(self, bot, key='tfidf_vectorizer'):
        self.bot_id = bot.id
        self._dump_key = '{}{}'.format(bot.dump_key_prefix, key)
        self.vectorizer = self.persistence.load(self.bot_id, self.dump_key)
        if self.vectorizer is None:
            # Note: token_patternは1文字のデータを除外しない設定
            self.vectorizer = SkTfidfVectorizer(use_idf=True, token_pattern=u'(?u)\\b\\w+\\b')
        return self

    def fit(self, sentences):
        self._init_check()
        self.vectorizer.fit(sentences)
        self.persistence.dump(self.vectorizer, self.bot_id, self.dump_key)

    def transform(self, sentences):
        self._init_check()
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

    def _init_check(self):
        if self.vectorizer is None:
            raise ValueError('vectorizer is not init')
