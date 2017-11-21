import numpy as np
import pandas as pd

from app.shared.logger import logger
from app.shared.constants import Constants


class LearnController:
    def __init__(self, context):
        self.bot = context.current_bot
        self.factory = context.get_factory()

    def perform(self):
        logger.info('start')
        logger.debug('bot_id: %s' % self.bot.id)

        self._vocabulary_learn()

        self._learn_bot()

        result = self._evaluate()

        logger.info('end')

        return result

    def _vocabulary_learn(self):
        logger.info('load all get_datasource')
        question_answers = self.factory.get_datasource().question_answers.all()
        ratings = self.factory.get_datasource().ratings.all()
        all_questions = pd.concat([question_answers['question'], ratings['question']])

        logger.info('tokenize all')
        tokenized_sentences = self.factory.get_tokenizer().tokenize(all_questions)

        logger.info('vectorize all')
        vectorized_features = self.factory.get_vectorizer().fit_transform(tokenized_sentences)

        logger.info('reduce all')
        reduced_features = self.factory.get_reducer().fit_transform(vectorized_features)

        logger.info('normalize all')
        self.factory.get_normalizer().fit(reduced_features)

    def _learn_bot(self):
        logger.info('load question_answers and ratings')
        bot_qa_data = self.factory.get_datasource().question_answers.by_bot(self.bot.id)
        bot_ratings_data = self.factory.get_datasource().ratings.with_good_by_bot(self.bot.id)

        all_questions = np.array(pd.concat([bot_qa_data['question'], bot_ratings_data['question']]))
        all_answer_ids = np.array(pd.concat([bot_qa_data['question_answer_id'], bot_ratings_data['question_answer_id']]), dtype=np.int)

        # Note: 空のテキストにラベル0を対応付けるために強制的にトレーニングセットを追加
        all_questions = np.append(all_questions, [''] * Constants.COUNT_OF_APPEND_BLANK)
        all_answer_ids = np.append(all_answer_ids, [Constants.CLASSIFY_FAILED_ANSWER_ID] * Constants.COUNT_OF_APPEND_BLANK)

        logger.info('tokenize question_answers')
        bot_tokenized_sentences = self.factory.get_tokenizer().tokenize(all_questions)

        logger.info('vectorize get_datasource')
        bot_features = self.factory.get_vectorizer().transform(bot_tokenized_sentences)

        logger.info('fit')
        self.factory.core.fit(
                bot_features,
                all_answer_ids,
            )

    def _evaluate(self):
        return {
            'accuracy': 0,
            'precision': 0,
            'recall': 0,
            'f1': 0,
        }
