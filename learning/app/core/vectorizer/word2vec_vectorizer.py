import inject
from sklearn.feature_extraction.text import TfidfVectorizer as SkTfidfVectorizer
from app.shared.current_bot import CurrentBot
from app.shared.datasource.datasource import Datasource


class Word2vecVectorizer:
    @inject.params(bot=CurrentBot, datasource=Datasource)
    def __init__(self, bot=None, datasource=None):
        self.bot = bot
        self.persistence = datasource.persistence
        self.vectorizer = self.persistence.load(self.dump_key)
        # if self.vectorizer is None:
        #     # Note: token_patternは1文字のデータを除外しない設定
        #     self.vectorizer = SkTfidfVectorizer(use_idf=True, token_pattern=u'(?u)\\b\\w+\\b')

    def fit(self, sentences):
        print('fit')
        # self.vectorizer.fit(sentences)

    # def transform(self, sentences):
    #     return self.vectorizer.transform(sentences)
    #
    # def fit_transform(self, sentences):
    #     self.fit(sentences)
    #     return self.transform(sentences)
    #
    # @property
    # def dump_key(self):
    #     return 'dump_tfidf_vectorizer'
