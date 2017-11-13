import inject
from app.shared.logger import logger
from app.factories.cosine_similarity_factory import CosineSimilarityFactory


class ReplyController(object):
    @inject.params(factory=CosineSimilarityFactory)
    def __init__(self, factory=None):
        self.factory = factory

    def perform(self, text):
        logger.info('start')
        logger.debug('question: %s' % text)

        logger.info('before action')
        texts = self.factory.core.before_reply([text])

        logger.info('tokenize question')
        tokenized_sentences = self.factory.get_tokenizer().tokenize(texts)
        logger.debug(tokenized_sentences)

        logger.info('vectorize question')
        vectorized_features = self.factory.get_vectorizer().transform(tokenized_sentences)
        logger.debug(vectorized_features)

        logger.info('reduce question')
        reduced_features = self.factory.get_reducer().transform(vectorized_features)

        logger.info('normalize question')
        normalized_features = self.factory.get_normalizer().transform(reduced_features)

        logger.info('predict')
        data_frame = self.factory.core.predict(normalized_features)

        logger.info('unique and sort')
        data_frame = data_frame.drop_duplicates(subset='question_answer_id', keep='first')
        data_frame = data_frame.sort_values(by='probability', ascending=False)

        logger.info('after action')
        results = self.factory.core.after_reply(text, data_frame)

        results = results.to_dict('records')[:10]

        for row in results:
            logger.debug(row)

        logger.info('end')

        return {
            'question_feature_count': self.factory.get_vectorizer().extract_feature_count(tokenized_sentences),
            'results': results,
            'noun_count': self.factory.get_tokenizer().extract_noun_count(text),
            'verb_count': self.factory.get_tokenizer().extract_verb_count(text),
        }
