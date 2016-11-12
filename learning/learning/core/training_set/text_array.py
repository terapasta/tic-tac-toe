from learning.core.nlang import Nlang
from sklearn.feature_extraction.text import CountVectorizer

class TextArray:
    def __init__(self, data):
        self.data = data

    def to_vec(self):
        count_vectorizer = CountVectorizer()
        feature_vectors = count_vectorizer.fit_transform(self.__splited_data())
        self._vocabulary = count_vectorizer.get_feature_names()
        return feature_vectors

    def __splited_data(self):
        splited_data = []
        for datum in self.data:
            splited_data.append(Nlang.split(datum))
        return splited_data

    @property
    def vocabulary(self):
        return self._vocabulary
