from injector import inject

from app.core.tokenizer.mecab_tokenizer import MecabTokenizer
from app.core.vectorizer.tfidf_vectorizer import TfidfVectorizer
from app.core.estimator.logistic_regression import LogisticRegression as LogisticRegressionEstimator
from app.core.logistic_regression import LogisticRegression
from app.core.reducer.pass_reducer import PassReducer
from app.core.normalizer.pass_normalizer import PassNormalizer
from app.factories.base_factory import BaseFactory
from app.shared.datasource.datasource import Datasource


class LogisticRegressionFactory(BaseFactory):
    @inject
    def __init__(self, bot, datasource: Datasource, feedback):
        self.datasource = datasource
        self.tokenizer = MecabTokenizer.new()
        self.vectorizer = TfidfVectorizer.new(datasource=self.datasource)
        self.reducer = PassReducer.new(datasource=self.datasource)
        self.normalizer = PassNormalizer.new(datasource=self.datasource)
        self.estimator = LogisticRegressionEstimator.new(datasource=self.datasource)
        self.__core = LogisticRegression.new(
            bot=bot,
            datasource=self.datasource,
            estimator=self.estimator,
        )
        self.__feedback = feedback

    def get_bot(self):
        return self.bot

    def get_tokenizer(self):
        return self.tokenizer

    def get_vectorizer(self):
        return self.vectorizer

    def get_reducer(self):
        return self.reducer

    def get_normalizer(self):
        return self.normalizer

    def get_datasource(self):
        return self.datasource

    def get_estimator(self):
        return self.estimator

    @property
    def core(self):
        return self.__core

    @property
    def feedback(self):
        return self.__feedback
