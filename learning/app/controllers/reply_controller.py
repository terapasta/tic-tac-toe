import numpy as np
from app.shared.logger import logger
from app.shared.current_bot import CurrentBot
from app.factories.cosine_similarity_factory import CosineSimilarityFactory


class ReplyController:
    def __init__(self, bot=None, factory=None):
        self.bot = bot if bot is not None else CurrentBot()
        self._factory = factory if factory is not None else CosineSimilarityFactory()

    def perform(self, text):
        self.write_process_log('start')
        logger.debug('question: %s' % text)

        self.write_process_log('load learning_training_messages')
        bot_learning_training_messages_data = self._factory.get_learning_training_messages().by_bot(self.bot.id)

        self.write_process_log('tokenize learning_training_messages')
        bot_tokenized_sentences = self._factory.get_tokenizer().tokenize(bot_learning_training_messages_data['question'])

        self.write_process_log('vectorize learning_training_messages')
        bot_features = self._factory.get_vectorizer().transform(bot_tokenized_sentences)

        self.write_process_log('tokenize question')
        tokenized_sentences = self._factory.get_tokenizer().tokenize([text])
        logger.debug(tokenized_sentences)

        self.write_process_log('vectorize question')
        question_features = self._factory.get_vectorizer().transform(tokenized_sentences)
        logger.debug(question_features)

        self.write_process_log('predict')
        probabilities = self._factory.get_estimator().predict(question_features, bot_features)

        self.write_process_log('sort')
        sorted_data = sorted(
                zip(bot_learning_training_messages_data['question_answer_id'], probabilities),
                key=lambda x: x[1],
                reverse=True
            )
        results = list(map(
                (lambda x: {
                    'question_answer_id': float(x[0]),
                    'probability': x[1],
                }),
                sorted_data
            ))
        for row in results[:10]:
            logger.debug(row)

        self.write_process_log('end')

        return {
            'question_feature_count': np.count_nonzero(question_features.toarray()),
            'results': results[:10],
        }

    def write_process_log(self, process_name):
        logger.info('>> ReplyController#perform : %s' % process_name)
