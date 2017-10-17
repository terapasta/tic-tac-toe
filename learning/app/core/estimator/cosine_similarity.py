import inject
from sklearn.metrics.pairwise import cosine_similarity
from app.shared.logger import logger
from app.shared.current_bot import CurrentBot


class CosineSimilarity:
    @inject.params(bot=CurrentBot)
    def __init__(self, tokenizer, vectorizer, reducer, normalizer, datasource, bot=None):
        self.bot = bot if bot is not None else CurrentBot()
        self.tokenizer = tokenizer
        self.vectorizer = vectorizer
        self.reducer = reducer
        self.normalizer = normalizer
        self.bot_question_answers_data = datasource.question_answers.by_bot(self.bot.id)

    def fit(self, x, y):
        logger.info('PASS')

    def predict(self, question_features):
        bot_tokenized_sentences = self.tokenizer.tokenize(self.bot_question_answers_data['question'])
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
        return 'dump_cosine_similarity'
