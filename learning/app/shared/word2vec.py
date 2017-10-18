import gensim

class Word2vec(object):
    __shared_state = {}

    def __init__(self):
        self.__dict__ = self.__shared_state

    def init(self):
        self.model = gensim.models.KeyedVectors.load_word2vec_format('dumps/entity_vector.model.bin', binary=True)