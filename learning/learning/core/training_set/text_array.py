from learning.core.nlang import Nlang
from learning.log import logger
from sklearn.feature_extraction.text import CountVectorizer

class TextArray:
    def __init__(self, data, vocabulary=None):
        self.data = data
        self._vocabulary = vocabulary

    def to_vec(self, type=None):
        count_vectorizer = self.__build_count_vectorizer()
        feature_vectors = count_vectorizer.transform(self.__splited_data())
        if type == 'array':
            feature_vectors = feature_vectors.toarray()
        return feature_vectors

    def __build_count_vectorizer(self):
        if self._vocabulary is None:
            count_vectorizer = CountVectorizer()
            count_vectorizer.fit(self.__splited_data())
            self._vocabulary = count_vectorizer.get_feature_names()
        else:
            count_vectorizer = CountVectorizer(vocabulary=self.vocabulary)
        return count_vectorizer

    def __splited_data(self):
        splited_data = []
        for datum in self.data:
            splited_data.append(Nlang.split(datum))
        return splited_data

    @property
    def vocabulary(self):
        return self._vocabulary
