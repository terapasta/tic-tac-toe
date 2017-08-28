import numpy as np
from app.shared.logger import logger
from app.shared.current_bot import CurrentBot
from app.shared.constants import Constants
from app.factories.cosine_similarity_factory import CosineSimilarityFactory


class LearnController:
    def __init__(self, bot=None, factory=None):
        self.bot = bot if bot is not None else CurrentBot()
        self._factory = factory if factory is not None else CosineSimilarityFactory()

    def perform(self):
        logger.info('start')
        logger.debug('bot_id: %s' % self.bot.id)

        self._vocabulary_learn()

        self._learn()

        result = self._evaluate()

        logger.info('end')

        return result

    def _vocabulary_learn(self):
        logger.info('load all learning_training_messages')
        all_learning_training_messages_data = self._factory.get_learning_training_messages().all()

        logger.info('tokenize all learning_training_messages')
        tokenized_sentences = self._factory.get_tokenizer().tokenize(all_learning_training_messages_data['question'])

        logger.info('vocabulary fit')
        self._factory.get_vectorizer().fit(tokenized_sentences)

    def _learn(self):
        logger.info('load learning_training_messages')
        bot_learning_training_messages_data = self._factory.get_learning_training_messages().by_bot(self.bot.id)

        # Note: 空のテキストにラベル0を対応付けるために強制的にトレーニングセットを追加
        questions = np.array(bot_learning_training_messages_data['question'])
        questions = np.append(questions, [''] * Constants.COUNT_OF_APPEND_BLANK)
        question_answer_ids = np.array(bot_learning_training_messages_data['question_answer_id'], dtype=np.int)
        question_answer_ids = np.append(question_answer_ids, [Constants.CLASSIFY_FAILED_ANSWER_ID] * Constants.COUNT_OF_APPEND_BLANK)

        logger.info('tokenize learning_training_messages')
        bot_tokenized_sentences = self._factory.get_tokenizer().tokenize(questions)

        logger.info('vectorize learning_training_messages')
        bot_features = self._factory.get_vectorizer().transform(bot_tokenized_sentences)

        logger.info('fit')
        self._factory.get_estimator().fit(
                bot_features,
                question_answer_ids,
            )

    def _evaluate(self):
        return {
            'accuracy': 0,
            'precision': 0,
            'recall': 0,
            'f1': 0,
        }
