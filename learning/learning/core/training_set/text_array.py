import numpy as np

from learning.core.nlang import Nlang
from learning.log import logger
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.decomposition import TruncatedSVD
from sklearn.preprocessing import Normalizer


class TextArray:
    def __init__(self, vectorizer=None):
        self.separated_sentences = []
        self._vectorizer = vectorizer
        self._lsa = None
        self._normalizer = None

    def to_vec(self, sentences):
        logger.debug('TextArray#to_vec start')
        self.separated_sentences = Nlang.batch_split(np.array(sentences))

        self._vectorizer = self.__bulid_vectorizer(self.separated_sentences)
        feature_vectors = self._vectorizer.transform(self.separated_sentences)

        self._lsa = self.__bulid_lsa(feature_vectors)
        reduced_vectors = self._lsa.transform(feature_vectors)

        self._normalizer = self.__build_normalizer(reduced_vectors)
        reduced_vectors = self._normalizer.transform(reduced_vectors)

        logger.debug('TextArray#to_vec features: %s' % reduced_vectors)
        logger.debug('TextArray#to_vec end')
        return reduced_vectors

    def __bulid_vectorizer(self, sentences):
        if self._vectorizer is not None:
            return self._vectorizer

        # token_patternは1文字のデータを除外しない設定
        vectorizer = TfidfVectorizer(use_idf=True, token_pattern=u'(?u)\\b\\w+\\b')
        vectorizer.fit(self.separated_sentences)
        return vectorizer

    def __bulid_lsa(self, features):
        if self._lsa is not None:
            return self._lsa

        # NOTE:
        #   n_componentsは削減後の次元数。
        #   条件: k must be between 1 and min(A.shape)
        n_components = min(features.shape)
        if n_components > 1:
            n_components = (n_components - 1)
        lsa = TruncatedSVD(n_components=n_components, algorithm='randomized', n_iter=10, random_state=42)
        lsa.fit(features)
        return lsa

    def __build_normalizer(self, features):
        if self._normalizer is not None:
            return self._normalizer

        normalizer = Normalizer(copy=False)
        normalizer.fit(features)
        return normalizer

    @property
    def vectorizer(self):
        return self._vectorizer
