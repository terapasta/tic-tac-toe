from app.core.tokenizer.mecab_tokenizer import MecabTokenizer
from app.core.vectorizer.tfidf_vectorizer import TfidfVectorizer
from app.core.estimator.logistic_regression import LogisticRegression
from app.shared.datasource.database.learning_training_messages import LearningTrainingMessages


class LogisticRegressionFactory:
    def __init__(self, tokenizer=None, vectorizer=None, estimator=None, ltm=None):
        self.tokenizer = tokenizer if tokenizer is not None else MecabTokenizer()
        self.vectorizer = vectorizer if vectorizer is not None else TfidfVectorizer()
        self.estimator = estimator if estimator is not None else LogisticRegression()
        self.learning_training_messages = ltm if ltm is not None else LearningTrainingMessages()

    def get_tokenizer(self):
        return self.tokenizer

    def get_vectorizer(self):
        return self.vectorizer

    def get_learning_training_messages(self):
        return self.learning_training_messages

    def get_estimator(self):
        return self.estimator
