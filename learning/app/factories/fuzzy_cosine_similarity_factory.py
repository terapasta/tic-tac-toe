from injector import inject

from app.core.tokenizer.fuzzy_term_tokenizer import FuzzyTermTokenizer
from app.core.vectorizer.fuzzy_term_vectorizer import FuzzyTermVectorizer
from app.core.reducer.pass_reducer import PassReducer
from app.core.normalizer.pass_normalizer import PassNormalizer
from app.core.estimator.pass_estimator import PassEstimator
from app.core.cosine_similarity import CosineSimilarity
from app.factories.base_factory import BaseFactory
from app.shared.datasource.datasource import Datasource


class FuzzyCosineSimilarityFactory(BaseFactory):
    @inject
    def __init__(self, bot, datasource: Datasource, feedback):
        self.datasource = datasource
        self.tokenizer = FuzzyTermTokenizer.new()
        self.vectorizer = FuzzyTermVectorizer.new(datasource=self.datasource)
        self.reducer = PassReducer.new(datasource=self.datasource)
        self.normalizer = PassNormalizer.new(datasource=self.datasource)
        self.estimator = PassEstimator.new(datasource=self.datasource)
        self.__core = CosineSimilarity.new(
            bot=bot,
            datasource=self.datasource,
        )
        self.__feedback = feedback

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

    @property
    def feedback(self):
        return self.__feedback
