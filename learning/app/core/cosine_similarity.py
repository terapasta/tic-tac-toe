from injector import inject
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
from app.shared.logger import logger

from app.core.tokenizer.mecab_tokenizer import MecabTokenizer
from app.core.vectorizer.tfidf_vectorizer import TfidfVectorizer
from app.core.reducer.pass_reducer import PassReducer
from app.core.normalizer.pass_normalizer import PassNormalizer
from app.shared.datasource.datasource import Datasource
from app.core.base_core import BaseCore


class CosineSimilarity(BaseCore):
    @inject
    def __init__(self, bot, tokenizer: MecabTokenizer, vectorizer: TfidfVectorizer, reducer: PassReducer, normalizer: PassNormalizer, datasource: Datasource):
        self.bot = bot
        self.tokenizer = tokenizer
        self.vectorizer = vectorizer
        self.reducer = reducer
        self.normalizer = normalizer
        question_answers = datasource.question_answers.by_bot(self.bot.id)
        ratings = datasource.ratings.with_good_by_bot(self.bot.id)
        columns = ['question', 'question_answer_id']
        self.bot_question_answers_data = pd.concat([question_answers[columns], ratings[columns]])

    def fit(self, x, y):
        logger.info('PASS')

    def predict(self, question_features):
        bot_tokenized_sentences = self.tokenizer.tokenize(self.bot_question_answers_data['question'])
        if len(bot_tokenized_sentences) == 0:
            return self.__no_data()
        bot_features = self.vectorizer.transform(bot_tokenized_sentences)
        reduced_vectors = self.reducer.transform(bot_features)
        normalized_vectors = self.normalizer.transform(reduced_vectors)
        similarities = cosine_similarity(normalized_vectors, question_features)
        similarities = similarities.flatten()
        result = self.bot_question_answers_data.copy()
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
