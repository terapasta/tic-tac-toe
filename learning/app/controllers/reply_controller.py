import numpy as np
from app.shared.logger import logger
from app.shared.current_bot import CurrentBot
from app.factories.cosine_similarity_factory import CosineSimilarityFactory


class ReplyController:
    def __init__(self, bot=None, factory=None):
        self.bot = bot if bot is not None else CurrentBot()
        self._factory = factory if factory is not None else CosineSimilarityFactory()

    def perform(self, text):
        logger.info('start')
        logger.debug('question: %s' % text)

        logger.info('tokenize question')
        tokenized_sentences = self._factory.get_tokenizer().tokenize([text])
        logger.debug(tokenized_sentences)

        logger.info('vectorize question')
        vectorized_features = self._factory.get_vectorizer().transform(tokenized_sentences)
        logger.debug(vectorized_features)

        logger.info('reduce question')
        reduced_features = self._factory.get_reducer().transform(vectorized_features)

        logger.info('normalize question')
        normalized_features = self._factory.get_normalizer().transform(reduced_features)

        logger.info('predict')
        data_frame = self._factory.get_estimator().predict(normalized_features)

        logger.info('sort')
        data_frame = data_frame.sort_values(by='probability', ascending=False)
        results = data_frame.to_dict('records')[:10]

        for row in results:
            logger.debug(row)

        logger.info('end')

        return {
            'question_feature_count': np.count_nonzero(normalized_features),
            'results': results,
        }
