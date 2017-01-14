from learning.core.nlang import Nlang
from learning.log import logger
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfVectorizer

class TextArray:
    def __init__(self, data, vectorizer=None):
        logger.debug('TextArray#__init__ start')
        self.data = data
        self._vectorizer = vectorizer

    # TODO 処理速度が遅いため改善したい
    def to_vec(self, type=None):
        logger.debug('TextArray#to_vec start')
        self._vectorizer = self.__build_vectorizer()
        feature_vectors = self._vectorizer.transform(self.__splited_data())
        if type == 'array':
            feature_vectors = feature_vectors.toarray()
        logger.debug('TextArray#to_vec end')
        return feature_vectors

    def __build_vectorizer(self):
        if self._vectorizer is not None:
            return self._vectorizer

        vectorizer = TfidfVectorizer(use_idf=False)
        vectorizer.fit(self.__splited_data())
        return vectorizer

    def __splited_data(self):
        splited_data = []
        for datum in self.data:
            splited_data.append(Nlang.split(datum))
        return splited_data

    @property
    def vectorizer(self):
        return self._vectorizer
