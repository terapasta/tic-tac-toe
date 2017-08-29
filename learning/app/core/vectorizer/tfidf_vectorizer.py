import inject
from sklearn.feature_extraction.text import TfidfVectorizer as SkTfidfVectorizer
from app.shared.current_bot import CurrentBot
from app.shared.loader import Loader


class TfidfVectorizer:
    @inject.params(bot=CurrentBot, loader=Loader)
    def __init__(self, bot=None, loader=None):
        self.bot = bot
        self.loader = loader
        self.vectorizer = self.loader.load(self.dump_path)
        if self.vectorizer is None:
            # Note: token_patternは1文字のデータを除外しない設定
            self.vectorizer = SkTfidfVectorizer(use_idf=True, token_pattern=u'(?u)\\b\\w+\\b')

    def fit(self, sentences):
        self.vectorizer.fit(sentences)
        self.loader.dump(self.vectorizer, self.dump_path)

    def transform(self, sentences):
        return self.vectorizer.transform(sentences)

    def fit_transform(self, sentences):
        self.fit(sentences)
        return self.transform(sentences)

    @property
    def dump_path(self):
        return self.bot.dump_dirpath + '/tfidf_vectorizer.pkl'
