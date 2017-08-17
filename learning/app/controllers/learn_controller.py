from app.shared.logger import logger
from app.shared.current_bot import CurrentBot
from app.factories.cosine_similarity_factory import CosineSimilarityFactory


class LearnController:
    def __init__(self, bot=None, factory=None):
        self.bot = bot if bot is not None else CurrentBot()
        self._factory = factory if factory is not None else CosineSimilarityFactory()

    def perform(self):
        self.write_process_log('start')
        logger.debug('bot_id: %s' % self.bot.id)

        self.write_process_log('load learning_training_messages')
        all_learning_training_messages_data = self._factory.get_learning_training_messages().all()

        self.write_process_log('tokenize learning_training_messages')
        tokenized_sentences = self._factory.get_tokenizer().tokenize(all_learning_training_messages_data['question'])

        self.write_process_log('fit')
        self._factory.get_vectorizer().fit(tokenized_sentences)

        self.write_process_log('end')

        return {
            'accuracy': 0,
            'precision': 0,
            'recall': 0,
            'f1': 0,
        }

    def write_process_log(self, process_name):
        logger.info('>> LearnController#perform : %s' % process_name)
