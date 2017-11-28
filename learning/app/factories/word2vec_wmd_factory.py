from injector import inject

from app.core.tokenizer.mecab_tokenizer_with_split import MecabTokenizerWithSplit
from app.core.reducer.pass_reducer import PassReducer
from app.core.normalizer.pass_normalizer import PassNormalizer
from app.core.vectorizer.pass_vectorizer import PassVectorizer
from app.core.estimator.pass_estimator import PassEstimator
from app.core.word2vec_wmd import Word2vecWmd
from app.factories.base_factory import BaseFactory
from app.feedback.pass_feedback import PassFeedback
from app.shared.datasource.datasource import Datasource


class Word2vecWmdFactory(BaseFactory):
    @inject
    def __init__(self, context, datasource: Datasource):
        datasource.persistence.init_by_bot(context.current_bot)
        self.datasource = datasource
        self.tokenizer = MecabTokenizerWithSplit.new()
        self.vectorizer = PassVectorizer.new(datasource=self.datasource)
        self.reducer = PassReducer.new(datasource=self.datasource)
        self.normalizer = PassNormalizer.new(datasource=self.datasource)
        self.estimator = PassEstimator.new(datasource=self.datasource)
        self.__feedback = PassFeedback.new()
        self.__core = Word2vecWmd.new(
            bot=context.current_bot,
            tokenizer=self.tokenizer,
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
        return self.__core

    @property
    def feedback(self):
        return self.__feedback
