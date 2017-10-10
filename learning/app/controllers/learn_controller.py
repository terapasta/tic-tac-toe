import inject

from app.shared.logger import logger
from app.shared.current_bot import CurrentBot
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

        result = self._evaluate()

        logger.info('end')

        return result

    def _vocabulary_learn(self):
        logger.info('data build all')
        tokenized_sentences = self._factory.get_data_builder().build_tokenized_vocabularies()

        logger.info('vectorize all')
        vectorized_features = self._factory.get_vectorizer().fit_transform(tokenized_sentences)

        logger.info('reduce all')
        reduced_features = self._factory.get_reducer().fit_transform(vectorized_features)

        logger.info('normalize all')
        self._factory.get_normalizer().fit(reduced_features)

    def _learn_bot(self):
        logger.info('data build')
        bot_tokenized_sentences, question_answer_ids = self._factory.get_data_builder().build_learning_data(self.bot.id)

        logger.info('vectorize get_datasource')
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
