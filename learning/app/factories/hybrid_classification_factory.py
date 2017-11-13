import inject

from app.core.tokenizer.mecab_tokenizer import MecabTokenizer
from app.core.vectorizer.tfidf_vectorizer import TfidfVectorizer
from app.core.estimator.naive_bayes import NaiveBayes
from app.core.reducer.pass_reducer import PassReducer
from app.core.normalizer.pass_normalizer import PassNormalizer
from app.core.hybrid_classification import HybridClassification
from app.shared.datasource.datasource import Datasource


class HybridClassificationFactory:
    @inject.params(
        tokenizer=MecabTokenizer,
        vectorizer=TfidfVectorizer,
        reducer=PassReducer,
        normalizer=PassNormalizer,
        estimator=NaiveBayes,
        datasource=Datasource,
    )
    def __init__(self, data_builder=None, tokenizer=None, vectorizer=None, reducer=None, normalizer=None, datasource=None, estimator=None, core=None):
        self.tokenizer = tokenizer
        self.vectorizer = vectorizer
        self.reducer = reducer
        self.normalizer = normalizer
        self.datasource = datasource
        self.estimator = estimator
        if core is not None:
            self._core = core
        else:
            self._core = HybridClassification(
                    tokenizer=self.tokenizer,
                    vectorizer=self.vectorizer,
                    reducer=self.reducer,
                    normalizer=self.normalizer,
                    estimator=self.estimator,
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

    def get_datasource(self):
        return self.datasource

    def get_estimator(self):
        return self.estimator

    @property
    def core(self):
        return self._core
