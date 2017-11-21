from injector import inject

from app.core.tokenizer.mecab_tokenizer import MecabTokenizer
from app.core.vectorizer.tfidf_vectorizer import TfidfVectorizer
from app.core.estimator.logistic_regression import LogisticRegression as LogisticRegressionEstimator
from app.core.logistic_regression import LogisticRegression
from app.core.reducer.pass_reducer import PassReducer
from app.core.normalizer.pass_normalizer import PassNormalizer
from app.shared.datasource.datasource import Datasource


class LogisticRegressionFactory:
    @inject
    def __init__(self, context, tokenizer: MecabTokenizer, vectorizer: TfidfVectorizer, reducer: PassReducer, normalizer: PassNormalizer, datasource: Datasource, estimator: LogisticRegressionEstimator):
        persistence = datasource.persistence.init_by_bot(context.current_bot)
        self.tokenizer = tokenizer.set_persistence(persistence)
        self.vectorizer = vectorizer.set_persistence(persistence)
        self.reducer = reducer.set_persistence(persistence)
        self.normalizer = normalizer.set_persistence(persistence)
        self.estimator = estimator.set_persistence(persistence)
        self.datasource = datasource
        self.__core = LogisticRegression(
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
