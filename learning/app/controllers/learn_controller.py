import inject
import numpy as np
import pandas as pd

from app.shared.logger import logger
from app.shared.current_bot import CurrentBot
from app.shared.constants import Constants
from app.factories.cosine_similarity_factory import CosineSimilarityFactory


class LearnController:
    @inject.params(bot=CurrentBot, factory=CosineSimilarityFactory)
    def __init__(self, bot=None, factory=None):
        self.bot = bot
        self._factory = factory

    def perform(self):
        logger.info('start')
        logger.debug('bot_id: %s' % self.bot.id)

        self._vocabulary_learn()

        self._learn_bot()

        self._extend_learn()

        result = self._evaluate()

        logger.info('end')

        return result

    def _vocabulary_learn(self):
        logger.info('load all get_datasource')
        question_answers = self._factory.get_datasource().question_answers.all()
        ratings = self._factory.get_datasource().ratings.all()
        all_questions = pd.concat([question_answers['question'], ratings['question']])

        logger.info('tokenize all')
        tokenized_sentences = self._factory.get_tokenizer().tokenize(all_questions)

        logger.info('vectorize all')
        vectorized_features = self._factory.get_vectorizer().fit_transform(tokenized_sentences)

        logger.info('reduce all')
        reduced_features = self._factory.get_reducer().fit_transform(vectorized_features)

        logger.info('normalize all')
        self._factory.get_normalizer().fit(reduced_features)

    def _learn_bot(self):
        logger.info('load question_answers')
        bot_question_answers_data = self._factory.get_datasource().question_answers.by_bot(self.bot.id)

        # Note: 空のテキストにラベル0を対応付けるために強制的にトレーニングセットを追加
        questions = np.array(bot_question_answers_data['question'])
        questions = np.append(questions, [''] * Constants.COUNT_OF_APPEND_BLANK)
        question_answer_ids = np.array(bot_question_answers_data['question_answer_id'], dtype=np.int)
        question_answer_ids = np.append(question_answer_ids, [Constants.CLASSIFY_FAILED_ANSWER_ID] * Constants.COUNT_OF_APPEND_BLANK)

        logger.info('tokenize question_answers')
        bot_tokenized_sentences = self._factory.get_tokenizer().tokenize(questions)

        logger.info('vectorize get_datasource')
        bot_features = self._factory.get_vectorizer().transform(bot_tokenized_sentences)

        logger.info('fit')
        self._factory.get_estimator().fit(
                bot_features,
                question_answer_ids,
            )

    def _extend_learn(self):
        logger.info('extend learn')
        self._factory.get_extension().learn(self.bot.id)

    def _evaluate(self):
        return {
            'accuracy': 0,
            'precision': 0,
            'recall': 0,
            'f1': 0,
        }
