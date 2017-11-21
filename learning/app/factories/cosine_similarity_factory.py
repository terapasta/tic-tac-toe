from injector import inject

from app.core.tokenizer.mecab_tokenizer import MecabTokenizer
from app.core.vectorizer.tfidf_vectorizer import TfidfVectorizer
from app.core.reducer.pass_reducer import PassReducer
from app.core.normalizer.pass_normalizer import PassNormalizer
from app.core.estimator.pass_estimator import PassEstimator
from app.core.cosine_similarity import CosineSimilarity
from app.shared.base_cls import BaseCls
from app.shared.datasource.datasource import Datasource


class CosineSimilarityFactory(BaseCls):
    @inject
    def __init__(self, context, tokenizer: MecabTokenizer, vectorizer: TfidfVectorizer, reducer: PassReducer, normalizer: PassNormalizer, estimator: PassEstimator, datasource: Datasource):
        persistence = datasource.persistence.init_by_bot(context.current_bot)
        self.tokenizer = tokenizer.set_persistence(persistence)
        self.vectorizer = vectorizer.set_persistence(persistence)
        self.reducer = reducer.set_persistence(persistence)
        self.normalizer = normalizer.set_persistence(persistence)
        self.estimator = estimator.set_persistence(persistence)
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
