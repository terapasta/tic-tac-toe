import inject

from app.core.tokenizer.mecab_tokenizer import MecabTokenizer
from app.core.vectorizer.tfidf_vectorizer import TfidfVectorizer
from app.core.reducer.pass_reducer import PassReducer
from app.core.normalizer.pass_normalizer import PassNormalizer
from app.core.estimator.pass_estimator import PassEstimator
from app.core.cosine_similarity import CosineSimilarity
from app.shared.datasource.datasource import Datasource


class CosineSimilarityFactory:
    @inject.params(
        tokenizer=MecabTokenizer,
        vectorizer=TfidfVectorizer,
        reducer=PassReducer,
        normalizer=PassNormalizer,
        estimator=PassEstimator,
        datasource=Datasource,
    )
    def __init__(self, context, tokenizer=None, vectorizer=None, reducer=None, normalizer=None, estimator=None, datasource=None):
        bot = context.current_bot
        self.tokenizer = tokenizer.init_by_bot(bot)
        self.vectorizer = vectorizer.init_by_bot(bot)
        self.reducer = reducer.init_by_bot(bot)
        self.normalizer = normalizer.init_by_bot(bot)
        self.estimator = estimator.init_by_bot(bot)
        self.datasource = datasource
        self.__core = CosineSimilarity(
            bot=context.current_bot,
            tokenizer=self.tokenizer,
            vectorizer=self.vectorizer,
            reducer=self.reducer,
            normalizer=self.normalizer,
            datasource=self.datasource,
        )

    def get_tokenizer(self):
        return self.tokenizer

    def get_vectorizer(self):
        return self.vectorizer

    def get_reducer(self):
        return self.reducer

    def get_normalizer(self):
        return self.normalizer

    def get_estimator(self):
        return self.estimator

    def get_datasource(self):
        return self.datasource

    @property
    def core(self):
        return self.__core
