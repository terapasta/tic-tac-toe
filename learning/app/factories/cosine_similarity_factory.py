import inject
from app.core.tokenizer.mecab_tokenizer import MecabTokenizer
from app.core.vectorizer.tfidf_vectorizer import TfidfVectorizer
from app.core.estimator.cosine_similarity import CosineSimilarity
from app.core.reducer.lsi import LSI
from app.core.normalizer.normalizer import Normalizer
from app.shared.datasource.database.learning_training_messages import LearningTrainingMessages


class CosineSimilarityFactory:
    @inject.params(
        tokenizer=MecabTokenizer,
        vectorizer=TfidfVectorizer,
        reducer=LSI,
        normalizer=Normalizer,
        ltm=LearningTrainingMessages,
    )
    def __init__(self, tokenizer=None, vectorizer=None, reducer=None, normalizer=None, ltm=None, estimator=None):
        self.tokenizer = tokenizer
        self.vectorizer = vectorizer
        self.reducer = reducer
        self.normalizer = normalizer
        self.learning_training_messages = ltm
        if estimator is not None:
            self.estimator = estimator
        else:
            self.estimator = CosineSimilarity(
                    self.tokenizer,
                    self.vectorizer,
                    self.reducer,
                    self.normalizer,
                    self.learning_training_messages,
                )

    def get_tokenizer(self):
        return self.tokenizer

    def get_vectorizer(self):
        return self.vectorizer

    def get_reducer(self):
        return self.reducer

    def get_normalizer(self):
        return self.normalizer

    def get_learning_training_messages(self):
        return self.learning_training_messages

    def get_estimator(self):
        return self.estimator
