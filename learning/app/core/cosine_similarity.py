import inject
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
from app.shared.logger import logger
from app.shared.app_status import AppStatus

from app.core.tokenizer.mecab_tokenizer import MecabTokenizer
from app.core.vectorizer.tfidf_vectorizer import TfidfVectorizer
from app.core.reducer.pass_reducer import PassReducer
from app.core.normalizer.pass_normalizer import PassNormalizer
from app.shared.datasource.file.question_answers import QuestionAnswers


class CosineSimilarity:
    @inject.params(
        tokenizer=MecabTokenizer,
        vectorizer=TfidfVectorizer,
        reducer=PassReducer,
        normalizer=PassNormalizer,
        question_answers=QuestionAnswers,
        app_status=AppStatus,
    )
    def __init__(self, tokenizer=None, vectorizer=None, reducer=None, normalizer=None, question_answers=None, app_status=None):
        self.bot = app_status.current_bot()
        self.tokenizer = tokenizer
        self.vectorizer = vectorizer
        self.reducer = reducer
        self.normalizer = normalizer
        self.bot_question_answers_data = question_answers.by_bot(self.bot.id)

    def fit(self, x, y):
        logger.info('PASS')

    def predict(self, question_features):
        bot_tokenized_sentences = self.tokenizer.tokenize(self.bot_question_answers_data['question'])
        if len(bot_tokenized_sentences) == 0:
            return self.__no_data
        bot_features = self.vectorizer.transform(bot_tokenized_sentences)
        reduced_vectors = self.reducer.transform(bot_features)
        normalized_vectors = self.normalizer.transform(reduced_vectors)
        similarities = cosine_similarity(normalized_vectors, question_features)
        similarities = similarities.flatten()
        result = self.bot_question_answers_data[['question', 'question_answer_id']].copy()
        result['probability'] = similarities
        return result

    def before_reply(self, sentences):
        logger.info('PASS')
        return sentences

    def after_reply(self, question, data_frame):
        logger.info('PASS')
        return data_frame

    @property
    def dump_key(self):
        return 'sk_cosine_similarity'

    def __no_data(self):
        return pd.DataFrame({
            'question': [],
            'question_answer_id': [],
            'probability': [],
        })
