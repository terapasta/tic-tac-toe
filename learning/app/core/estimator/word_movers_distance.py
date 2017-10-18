import gensim
import inject
from gensim.similarities import WmdSimilarity

from app.shared.current_bot import CurrentBot
from app.shared.logger import logger


class WordMoversDistance:
    @inject.params(bot=CurrentBot)
    def __init__(self, tokenizer, datasource, bot=None):
        self.bot = bot if bot is not None else CurrentBot()
        self.tokenizer = tokenizer
        self.bot_question_answers_data = datasource.question_answers.by_bot(self.bot.id)
        # TODO: modelのロードはシングルトンにしたい
        self.model = gensim.models.KeyedVectors.load_word2vec_format('dumps/entity_vector.model.bin', binary=True)

    def fit(self, x, y):
        logger.info('PASS')

    def predict(self, question_features):
        bot_tokenized_sentences = self.tokenizer.tokenize(self.bot_question_answers_data['question'])
        logger.debug(self.bot_question_answers_data)
        instance = WmdSimilarity(bot_tokenized_sentences, self.model, num_best=10)
        # NOTE: 形態素解析結果がスペース区切りの文字列になっていると、複数inputの類似検索が出来ないため一旦インデックス0を指定している
        result = instance[question_features[0]]

        indices = [x[0] for x in result]
        df = self.bot_question_answers_data.iloc[indices].copy()
        df['probability'] = [x[1] for x in result]
        return df