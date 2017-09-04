import inject
from app.core.tokenizer.mecab_tokenizer import MecabTokenizer
from app.core.vectorizer.tfidf_vectorizer import TfidfVectorizer
from app.core.estimator.cosine_similarity import CosineSimilarity
from app.core.reducer.lsi import LSI
from app.core.normalizer.normalizer import Normalizer
from app.shared.datasource.database.question_answers import QuestionAnswers


class CosineSimilarityFactory:
    @inject.params(
        tokenizer=MecabTokenizer,
        vectorizer=TfidfVectorizer,
        reducer=LSI,
        normalizer=Normalizer,
        question_answers=QuestionAnswers,
    )
    def __init__(self, tokenizer=None, vectorizer=None, reducer=None, normalizer=None, question_answers=None, estimator=None):
        self.tokenizer = tokenizer
        self.vectorizer = vectorizer
        self.reducer = reducer
        self.normalizer = normalizer
        self.question_answers = question_answers 
        if estimator is not None:
            self.estimator = estimator
        else:
            self.estimator = CosineSimilarity(
                    self.tokenizer,
                    self.vectorizer,
                    self.reducer,
                    self.normalizer,
                    self.question_answers,
                )

    def get_tokenizer(self):
        return self.tokenizer

    def get_vectorizer(self):
        return self.vectorizer

    def get_reducer(self):
        return self.reducer

    def get_normalizer(self):
        return self.normalizer

    def get_question_answers(self):
        return self.question_answers

    def get_estimator(self):
        return self.estimator
