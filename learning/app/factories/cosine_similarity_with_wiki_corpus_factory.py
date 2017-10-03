import inject
from app.core.tokenizer.mecab_tokenizer import MecabTokenizer
from app.core.vectorizer.gensim_tfidf_vectorizer import GensimTfidfVectorizer
from app.core.estimator.gensim_cosine_similarity import GensimCosineSimilarity
from app.core.reducer.gensim_lsi import GensimLSI
# from app.core.normalizer.normalizer import Normalizer
from app.core.normalizer.pass_normalizer import PassNormalizer
from app.shared.datasource.datasource import Datasource


class CosineSimilarityWithWikiCorpusFactory:
    @inject.params(
        tokenizer=MecabTokenizer,
        vectorizer=GensimTfidfVectorizer,
        reducer=GensimLSI,
        normalizer=PassNormalizer,
        datasource=Datasource,
    )
    def __init__(self, tokenizer=None, vectorizer=None, reducer=None, normalizer=None, datasource=None, estimator=None):
        self.tokenizer = tokenizer
        self.vectorizer = vectorizer
        self.reducer = reducer
        self.normalizer = normalizer
        self.datasource = datasource
        if estimator is not None:
            self.estimator = estimator
        else:
            self.estimator = GensimCosineSimilarity(
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
