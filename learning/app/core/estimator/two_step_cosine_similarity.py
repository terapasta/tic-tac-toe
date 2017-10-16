import inject
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity
from app.shared.logger import logger
from app.shared.current_bot import CurrentBot


class TwoStepCosineSimilarity:
    @inject.params(bot=CurrentBot)
    def __init__(self, tokenizer, vectorizer, reducer, normalizer, datasource, bot=None):
        self.bot = bot if bot is not None else CurrentBot()
        self.tokenizer = tokenizer
        self.vectorizer = vectorizer
        self.reducer = reducer
        self.normalizer = normalizer
        self.bot_question_answers_data = datasource.question_answers.by_bot(self.bot.id)
        self.bot_ratings = datasource.ratings.by_bot(self.bot_id)

    def fit(self, x, y):
        logger.info('PASS')

    def predict(self, question_features):
        bot_tokenized_sentences = self.tokenizer.tokenize(self.bot_ratings['question'])
        bot_features = self.vectorizer.tokenize(bot_tokenized_sentences)
        reduced_vectors = self.reducer.transform(bot_features)
        normalized_vectors = self.normalizer.transform(reduced_vectors)
        similarities = cosine_similarity(normalized_vectors, question_features)
        similarities = similarities.flatten()
        ratings = self.bot_question_answers_data[['question', 'question_answer_id']].copy()
        ratings['probability'] = similarities
        ratings = ratings.sort_values(by='probability', ascending=False)
        top_rate_question = ratings.to_dict('records')[:1]
        tokenized_sentences = self.tokenizer.tokenize(df['question'])
        tokenized_sentences = np.array(tokenized_sentences, dtype=object)
        tokenized_sentences = tokenized_sentences + ' MYOPE_QA_ID:' + df['question_answer_id'].astype(str)

        bot_tokenized_sentences = self.tokenizer.tokenize(self.bot_question_answers_data['question'])
        bot_features = self.vectorizer.transform(bot_tokenized_sentences)
        reduced_vectors = self.reducer.transform(bot_features)
        normalized_vectors = self.normalizer.transform(reduced_vectors)

        similarities = cosine_similarity(normalized_vectors, question_features)
        similarities = similarities.flatten()
        result = self.bot_question_answers_data[['question', 'question_answer_id']].copy()
        result['probability'] = similarities
        return result

    @property
    def dump_key(self):
        return 'dump_cosine_similarity'
