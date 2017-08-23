import numpy as np
from app.shared.logger import logger
from app.shared.current_bot import CurrentBot
from app.factories.cosine_similarity_factory import CosineSimilarityFactory


class ReplyController:
    def __init__(self, bot=None, factory=None):
        self.bot = bot if bot is not None else CurrentBot()
        self._factory = factory if factory is not None else CosineSimilarityFactory()

    def perform(self, text):
        self._write_process_log('start')
        logger.debug('question: %s' % text)

        self._write_process_log('tokenize question')
        tokenized_sentences = self._factory.get_tokenizer().tokenize([text])
        logger.debug(tokenized_sentences)

        self._write_process_log('vectorize question')
        question_features = self._factory.get_vectorizer().transform(tokenized_sentences)
        logger.debug(question_features)

        self._write_process_log('predict')
        data_frame = self._factory.get_estimator().predict(question_features)

        self._write_process_log('sort')
        data_frame = data_frame.sort_values(by='probability', ascending=False)
        results = data_frame.to_dict('records')[:10]

        for row in results:
            logger.debug(row)

        self._write_process_log('end')

        return {
            'question_feature_count': np.count_nonzero(question_features.toarray()),
            'results': results,
        }

    def _write_process_log(self, process_name):
        logger.info('>> ReplyController: %s' % process_name)
