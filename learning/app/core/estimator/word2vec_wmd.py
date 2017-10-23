import inject
from gensim.similarities import WmdSimilarity

from app.shared.app_status import AppStatus
from app.shared.logger import logger
from app.shared.word2vec import Word2vec


class Word2vecWmd:
    @inject.params(app_status=AppStatus, word2vec=Word2vec)
    def __init__(self, tokenizer, datasource, bot=None, word2vec=None, app_status=None):
        self.bot = app_status.current_bot()
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
        df = df[['question', 'question_answer_id']]
        df['probability'] = [x[1] for x in result]
        return df

    def before_reply(self, sentences):
        logger.info('PASS')
        return sentences

    def after_reply(self, question, data_frame):
        logger.info('PASS')
        return data_frame