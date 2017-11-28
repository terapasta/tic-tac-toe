import numpy as np
import pandas as pd

from app.shared.logger import logger
from app.shared.constants import Constants
from app.shared.base_cls import BaseCls


class LearnController(BaseCls):
    def __init__(self, context):
        self.bot = context.current_bot
        self.factory = context.get_factory()

    def perform(self):
        logger.info('start')
        logger.debug('bot_id: %s' % self.bot.id)

        # HACK: 各種fitをするために_learn_for_vocablaryを必ず最初に実行しないといけない
        self._learn_for_vocabulary()

        self.learn_for_feedback()

        self._learn_bot()

        result = self._evaluate()

        logger.info('end')

        return result

    def _learn_for_vocabulary(self):
        logger.info('load all get_datasource')
        question_answers = self.factory.get_datasource().question_answers.all()
        ratings = self.factory.get_datasource().ratings.all()
        all_questions = pd.concat([question_answers['question'], ratings['question']])

        logger.info('tokenize')
        tokenized_sentences = self.factory.get_tokenizer().tokenize(all_questions)

        logger.info('fit vectorizer')
        vectorized_features = self.factory.get_vectorizer().fit_transform(tokenized_sentences)

        logger.info('fit reducer')
        reduced_features = self.factory.get_reducer().fit_transform(vectorized_features)

        logger.info('fit normalizer')
        self.factory.get_normalizer().fit(reduced_features)

    def learn_for_feedback(self):
        logger.info('process good ratings')
        good_ratings = self.factory.get_datasource().ratings.with_good_by_bot(self.bot.id)
        good_rating_vectors = self._transform_to_vector(good_ratings['question'])
        self.factory.feedback.fit_for_good(good_rating_vectors, good_ratings['question_answer_id'])

        logger.info('process bad ratings')
        bad_ratings = self.factory.get_datasource().ratings.with_bad_by_bot(self.bot.id)
        bad_rating_vectors = self._transform_to_vector(bad_ratings['question'])
        self.factory.feedback.fit_for_bad(bad_rating_vectors, bad_ratings['question_answer_id'])

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

    def _transform_to_vector(self, sentences):
        tokenized_sentences = self.factory.get_tokenizer().tokenize(sentences)
        vectorized_features = self.factory.get_vectorizer().transform(tokenized_sentences)
        reduced_features = self.factory.get_reducer().transform(vectorized_features)
        normalized_features = self.factory.get_normalizer().transform(reduced_features)

        return normalized_features
