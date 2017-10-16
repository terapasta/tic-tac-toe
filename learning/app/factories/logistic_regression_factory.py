import inject

from app.core.tokenizer.mecab_tokenizer import MecabTokenizer
from app.core.vectorizer.tfidf_vectorizer import TfidfVectorizer
from app.core.estimator.logistic_regression import LogisticRegression
from app.core.reducer.pass_reducer import PassReducer
from app.core.normalizer.pass_normalizer import PassNormalizer
from app.core.extension.pass_extension import PassExtension
from app.shared.datasource.datasource import Datasource


class LogisticRegressionFactory:
    @inject.params(
        tokenizer=MecabTokenizer,
        vectorizer=TfidfVectorizer,
        reducer=PassReducer,
        normalizer=PassNormalizer,
        extension=PassExtension,
        datasource=Datasource,
        estimator=LogisticRegression,
    )
    def __init__(self, data_builder=None, tokenizer=None, vectorizer=None, reducer=None, normalizer=None, extension=None, datasource=None, estimator=None):
        self.tokenizer = tokenizer
        self.vectorizer = vectorizer
        self.reducer = reducer
        self.normalizer = normalizer
        self.datasource = datasource
        self.estimator = estimator
        if extension is not None:
            self.extension = extension
        else:
            self.extension = PassExtension()

    def get_data_builder(self):
        return self.data_builder

    def get_tokenizer(self):
        return self.tokenizer

    def get_vectorizer(self):
        return self.vectorizer

    def get_reducer(self):
        return self.reducer

    def get_normalizer(self):
        return self.normalizer

    def get_extension(self):
        return self.extension

    def get_datasource(self):
        return self.datasource

    def get_estimator(self):
        return self.estimator
