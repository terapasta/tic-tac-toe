from sklearn.feature_extraction.text import TfidfVectorizer as SkTfidfVectorizer


class TfidfVectorizer:
    def __init__(self):
        self.vectorizer = SkTfidfVectorizer(use_idf=True, token_pattern=u'(?u)\\b\\w+\\b')

    def fit(self, sentences):
        self.vectorizer.fit(sentences)

    def transform(self, sentences):
        self.vectorizer.transform(sentences)
