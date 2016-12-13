from learning.core.nlang import Nlang
from learning.log import logger
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfVectorizer

class TextArray:
    def __init__(self, data, vocabulary=None):
        self.data = data
        self._vocabulary = vocabulary

    # def to_vec(self, type=None):
    #     count_vectorizer = self.__build_count_vectorizer()
    #     feature_vectors = count_vectorizer.transform(self.__splited_data())
    #     if type == 'array':
    #         feature_vectors = feature_vectors.toarray()

    def to_vec(self, type=None):
        # vectorizer = TfidfVectorizer(norm='l2', max_df=0.1, min_df=1)
        # vectorizer = TfidfVectorizer(min_df=1, max_df=100)
        vectorizer = self.__build_vectorizer()
        feature_vectors = vectorizer.fit_transform(self.__splited_data())
        logger.debug("feature_vectors: %s" % feature_vectors)
        self._vectorizer = vectorizer
        self._vocabulary = vectorizer.get_feature_names()
        if type == 'array':
            feature_vectors = feature_vectors.toarray()
        return feature_vectors

    def __build_vectorizer(self):
        if self._vocabulary is None:
            # vectorizer = TfidfVectorizer()
            vectorizer = CountVectorizer()
            vectorizer.fit(self.__splited_data())
            self._vocabulary = vectorizer.get_feature_names()
        else:
            vectorizer = CountVectorizer(vocabulary=self.vocabulary)
            # vectorizer = TfidfVectorizer(vocabulary=self.vocabulary)
        return vectorizer

    def __splited_data(self):
        splited_data = []
        for datum in self.data:
            splited_data.append(Nlang.split(datum))
        return splited_data

    # def __is_bigger_than_min_tfidf(self, term, terms, tfidfs):
    #     if tfidfs[terms.index(term)] > 0.01:
    #         return True
    #     return False

    # TODO vectorizerをpklするならvacabularyは不要な気がする
    @property
    def vocabulary(self):
        return self._vocabulary

    @property
    def vectorizer(self):
        return self._vectorizer
