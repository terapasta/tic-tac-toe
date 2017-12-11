from injector import inject

from app.shared.logger import logger

from app.core.tokenizer.mecab_tokenizer_with_split import MecabTokenizerWithSplit
from app.shared.datasource.datasource import Datasource
from app.core.base_core import BaseCore
from app.shared.on_memory_learning.word2vec_wmd_store import Word2vecWmdStore


class Word2vecWmd(BaseCore):

    @inject
    def __init__(self, bot, tokenizer: MecabTokenizerWithSplit, datasource: Datasource, store=None):
        self.bot = bot
        self.tokenizer = tokenizer
        self.question_answers = datasource.question_answers
        if store is None:
            self.store = Word2vecWmdStore(question_answers=self.question_answers, tokenizer=self.tokenizer)
        else:
            self.store = store

    def fit(self, x, y):
        self.store.fit(self.bot.id)

    def predict(self, question_features):
        bot_question_answers_data = self.question_answers.by_bot(self.bot.id)

        result = self.store[self.bot.id][question_features[0]]

        indices = [x[0] for x in result]
        df = bot_question_answers_data.iloc[indices].copy()
        df = df[['question', 'question_answer_id']]
        df['probability'] = [x[1] for x in result]
        return df

    def before_reply(self, sentences):
        logger.info('PASS')
        return sentences

    def after_reply(self, question, data_frame):
        logger.info('PASS')
        return data_frame
