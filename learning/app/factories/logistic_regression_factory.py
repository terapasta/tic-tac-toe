from injector import inject

from app.core.tokenizer.mecab_tokenizer import MecabTokenizer
from app.core.vectorizer.tfidf_vectorizer import TfidfVectorizer
from app.core.estimator.logistic_regression import LogisticRegression as LogisticRegressionEstimator
from app.core.logistic_regression import LogisticRegression
from app.core.reducer.pass_reducer import PassReducer
from app.core.normalizer.pass_normalizer import PassNormalizer
from app.shared.base_cls import BaseCls
from app.shared.datasource.datasource import Datasource


class LogisticRegressionFactory(BaseCls):
    @inject
    def __init__(self, context, datasource: Datasource):
        datasource.persistence.init_by_bot(context.current_bot)
        self.datasource = datasource
        self.tokenizer = MecabTokenizer.new()
        self.vectorizer = TfidfVectorizer.new(datasource=self.datasource)
        self.reducer = PassReducer.new(datasource=self.datasource)
        self.normalizer = PassNormalizer.new(datasource=self.datasource)
        self.estimator = LogisticRegressionEstimator.new(datasource=self.datasource)
        self.datasource = datasource
        self.__core = LogisticRegression.new(
            bot=context.current_bot,
            datasource=self.datasource,
            estimator=self.estimator,
        )

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
