import inject
from gensim.similarities import WmdSimilarity

from app.shared.current_bot import CurrentBot
from app.shared.logger import logger
from app.shared.word2vec import Word2vec


class Word2vecWmd:
    @inject.params(bot=CurrentBot, word2vec=Word2vec)
    def __init__(self, tokenizer, datasource, bot=None, word2vec=None):
        self.bot = bot if bot is not None else CurrentBot()
        self.tokenizer = tokenizer
        self.bot_question_answers_data = datasource.question_answers.by_bot(self.bot.id)
        self.word2vec = word2vec

    def fit(self, x, y):
        logger.info('PASS')

    def predict(self, question_features):
        bot_tokenized_sentences = self.tokenizer.tokenize(self.bot_question_answers_data['question'])
        instance = WmdSimilarity(bot_tokenized_sentences, self.word2vec.model, num_best=10)
        # NOTE: 形態素解析結果がスペース区切りの文字列になっていると、複数inputの類似検索が出来ないため一旦インデックス0を指定している
        result = instance[question_features[0]]

        indices = [x[0] for x in result]
        df = self.bot_question_answers_data.iloc[indices].copy()
        df['probability'] = [x[1] for x in result]
        return df