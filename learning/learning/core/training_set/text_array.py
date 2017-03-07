from learning.core.nlang import Nlang
from learning.log import logger
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfVectorizer

class TextArray:
    def __init__(self, sentences, vectorizer=None):
        logger.debug('TextArray#__init__ start')
        self.sentences = sentences
        self.separated_sentences = Nlang.batch_split(self.sentences)
        self._vectorizer = vectorizer

    # TODO 処理速度が遅いため改善したい
    def to_vec(self, type=None):
        logger.debug('TextArray#to_vec start')
        self._vectorizer = self.__build_vectorizer()
        feature_vectors = self._vectorizer.transform(self.separated_sentences)
        if type == 'array':
            feature_vectors = feature_vectors.toarray()
        logger.debug('TextArray#to_vec end')
        return feature_vectors

    def __build_vectorizer(self):
        if self._vectorizer is not None:
            return self._vectorizer

        # token_patternは1文字のデータを除外しない設定
        vectorizer = TfidfVectorizer(use_idf=False, token_pattern=u'(?u)\\b\\w+\\b')
        # vectorizer = TfidfVectorizer(use_idf=False)
        vectorizer.fit(self.separated_sentences)
        return vectorizer

    @property
    def vectorizer(self):
        return self._vectorizer
