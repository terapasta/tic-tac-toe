from injector import inject

from app.core.preprocessor.synonym_expansion_preprocessor import SynonymExpansionPreprocessor
from app.core.tokenizer.mecab_tokenizer import MecabTokenizer
from app.core.vectorizer.tfidf_vectorizer import TfidfVectorizer
from app.core.estimator.naive_bayes import NaiveBayes
from app.core.reducer.pass_reducer import PassReducer
from app.core.normalizer.pass_normalizer import PassNormalizer
from app.core.hybrid_classification import HybridClassification
from app.factories.base_factory import BaseFactory
from app.shared.datasource.datasource import Datasource


class HybridClassificationFactory(BaseFactory):
    @inject
    def __init__(self, bot, datasource: Datasource, feedback):
        self.datasource = datasource
        self.preprocessor = SynonymExpansionPreprocessor.new(bot=bot, datasource=self.datasource)
        self.tokenizer = MecabTokenizer.new()
        self.vectorizer = TfidfVectorizer.new(datasource=self.datasource)
        self.reducer = PassReducer.new(datasource=self.datasource)
        self.normalizer = PassNormalizer.new(datasource=self.datasource)
        self.estimator = NaiveBayes.new(datasource=self.datasource)
        self.__core = HybridClassification.new(
                bot=bot,
                tokenizer=self.tokenizer,
                vectorizer=self.vectorizer,
                reducer=self.reducer,
                normalizer=self.normalizer,
                estimator=self.estimator,
                datasource=self.datasource,
            )
        self.__feedback = feedback

    def get_preprocessor(self):
        return self.preprocessor

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
