from sklearn.metrics.pairwise import cosine_similarity
from app.shared.logger import logger
from app.shared.current_bot import CurrentBot


class CosineSimilarity:
    def __init__(self, tokenizer, vectorizer, ltm, bot=None):
        self.bot = bot if bot is not None else CurrentBot()
        self.tokenizer = tokenizer
        self.vectorizer = vectorizer
        self.bot_learning_training_messages_data = ltm.by_bot(self.bot.id)

    def fit(self, x, y):
        logger.info('PASS')

    def predict(self, question_features):
        bot_tokenized_sentences = self.tokenizer.tokenize(self.bot_learning_training_messages_data['question'])
        bot_features = self.vectorizer.transform(bot_tokenized_sentences)
        similarities = cosine_similarity(bot_features, question_features)
        similarities = similarities.flatten()
        result = self.bot_learning_training_messages_data[['question', 'question_answer_id']].copy()
        result['probability'] = similarities
        return result

    @property
    def estimator_path(self):
        return ''
