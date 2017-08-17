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
        self._write_process_log('start')
        logger.debug('bot_id: %s' % self.bot.id)

        self._vocabulary_learn()

        self._learn()

        self._write_process_log('end')

        return {
            'accuracy': 0,
            'precision': 0,
            'recall': 0,
            'f1': 0,
        }

    def _vocabulary_learn(self):
        self._write_process_log('load all learning_training_messages')
        all_learning_training_messages_data = self._factory.get_learning_training_messages().all()

        self._write_process_log('tokenize all learning_training_messages')
        tokenized_sentences = self._factory.get_tokenizer().tokenize(all_learning_training_messages_data['question'])

        self._write_process_log('vocabulary fit')
        self._factory.get_vectorizer().fit(tokenized_sentences)

    def _learn(self):
        self._write_process_log('load learning_training_messages')
        bot_learning_training_messages_data = self._factory.get_learning_training_messages().by_bot(self.bot.id)

        # Note: 空のテキストにラベル0を対応付けるために強制的にトレーニングセットを追加
        questions = np.array(bot_learning_training_messages_data['question'])
        questions = np.append(questions, [''] * Constants.COUNT_OF_APPEND_BLANK)
        question_answer_ids = np.array(bot_learning_training_messages_data['question_answer_id'], dtype=np.int)
        question_answer_ids = np.append(question_answer_ids, [Constants.CLASSIFY_FAILED_ANSWER_ID] * Constants.COUNT_OF_APPEND_BLANK)

        self._write_process_log('tokenize learning_training_messages')
        bot_tokenized_sentences = self._factory.get_tokenizer().tokenize(questions)

        self._write_process_log('vectorize learning_training_messages')
        bot_features = self._factory.get_vectorizer().transform(bot_tokenized_sentences)

        self._write_process_log('fit')
        self._factory.get_estimator().fit(
                bot_features,
                question_answer_ids,
            )

    def _write_process_log(self, process_name):
        logger.info('>> LearnController: %s' % process_name)
