import inject

from app.core.tokenizer.mecab_tokenizer import MecabTokenizer
from app.core.vectorizer.tfidf_vectorizer import TfidfVectorizer
from app.core.two_steps_cosine_similarity import TwoStepsCosineSimilarity
# from app.core.reducer.lsi import LSI
# from app.core.normalizer.normalizer import Normalizer
from app.core.reducer.pass_reducer import PassReducer
from app.core.normalizer.pass_normalizer import PassNormalizer
from app.shared.datasource.datasource import Datasource


class TwoStepCosineSimilarityFactory:
    @inject.params(
        tokenizer=MecabTokenizer,
        vectorizer=TfidfVectorizer,
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
            self.estimator = TwoStepsCosineSimilarity(
                    self.tokenizer,
                    self.vectorizer,
                    self.reducer,
                    self.normalizer,
                    self.datasource,
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
