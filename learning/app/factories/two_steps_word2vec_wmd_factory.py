import inject

from app.core.estimator.two_steps_word2vec_wmd import TwoStepsWord2vecWmd
from app.core.tokenizer.mecab_tokenizer_with_split import MecabTokenizerWithSplit
from app.core.reducer.pass_reducer import PassReducer
from app.core.normalizer.pass_normalizer import PassNormalizer
from app.core.vectorizer.pass_vectorizer import PassVectorizer
from app.shared.datasource.datasource import Datasource


class TwoStepsWord2vecWmdFactory:
    @inject.params(
        tokenizer=MecabTokenizerWithSplit,
        vectorizer=PassVectorizer,
        reducer=PassReducer,
        normalizer=PassNormalizer,
        datasource=Datasource,
    )
    def __init__(self, data_builder=None, tokenizer=None, vectorizer=None, reducer=None, normalizer=None, datasource=None, estimator=None):
        self.tokenizer = tokenizer
        self.vectorizer = vectorizer
        self.reducer = reducer
        self.normalizer = normalizer
        self.datasource = datasource
        if estimator is not None:
            self.estimator = estimator
        else:
            self.estimator = TwoStepsWord2vecWmd(self.tokenizer, self.datasource)

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
