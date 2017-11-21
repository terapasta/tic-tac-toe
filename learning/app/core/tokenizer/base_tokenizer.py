from app.shared.base_cls import BaseCls


class BaseTokenizer(BaseCls):
    def __init__(self):
        raise NotImplementedError()

    def set_persistence(self, persistence, key):
        raise NotImplementedError()

    def tokenize(self, texts):
        raise NotImplementedError()

    def extract_noun_count(self, text):
        raise NotImplementedError()

    def extract_verb_count(self, text):
        raise NotImplementedError()
