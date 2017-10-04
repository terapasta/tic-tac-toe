import inject
from gensim.similarities import MatrixSimilarity
from app.shared.logger import logger
from app.shared.current_bot import CurrentBot


class GensimCosineSimilarity:
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
        self.bot_question_answers_data['question']
        bot_tokenized_sentences = self.tokenizer.tokenize(self.bot_question_answers_data['question'])
        bot_features = self.vectorizer.transform(bot_tokenized_sentences)
        reduced_vectors = self.reducer.transform(bot_features)
        normalized_vectors = self.normalizer.transform(reduced_vectors)

        # TODO: , num_features=1000が必要か確認する
        # TODO: fitでやってもいいかもしれない
        index = MatrixSimilarity(normalized_vectors)
        similarities = index[question_features][0]
        result = self.bot_question_answers_data[['question', 'question_answer_id']].copy()
        result['probability'] = similarities
        return result

    @property
    def dump_key(self):
        return 'dump_cosine_similarity'
