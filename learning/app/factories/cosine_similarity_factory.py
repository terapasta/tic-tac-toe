from app.core.tokenizer import MecabTokenizer
from app.core.vectorizer import TfidfVectorizer


class CosineSimilarityFactory:
    def __init__(self, tokenizer=None, vectorizer=None):
        self.tokenizer = tokenizer if tokenizer is not None else MecabTokenizer()
        self.vectorizer = vectorizer if vectorizer is not None else TfidfVectorizer()

    def get_tokenizer(self):
        return self.tokenizer

    def get_vectorizer(self):
        return self.vectorizer
