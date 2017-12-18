from sklearn.metrics.pairwise import cosine_similarity

from app.shared.logger import logger
from app.shared.base_cls import BaseCls


class ReplyController(BaseCls):
    def __init__(self, context):
        self.factory = context.get_factory()
        self.bot = context.current_bot
        self.pass_feedback = context.pass_feedback

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

        logger.info('reduce question')
        reduced_features = self.factory.get_reducer().transform(vectorized_features)

        logger.info('normalize question')
        normalized_features = self.factory.get_normalizer().transform(reduced_features)

        if not self.pass_feedback:
            normalized_features = self._transform_query_vector(normalized_features)

        logger.info('predict')
        data_frame = self.factory.core.predict(normalized_features)

        logger.info('unique and sort')
        data_frame = data_frame.drop_duplicates(subset='question_answer_id', keep='first')
        data_frame = data_frame.sort_values(by='probability', ascending=False)

        logger.info('after action')
        results = self.factory.core.after_reply(text, data_frame)
        results['question_answer_id'] = results['question_answer_id'].astype(int)

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

    def _transform_query_vector(self, query_vector):
        threshold = self.factory.get_datasource().learning_parameters.feedback_threshold(self.bot.id)
        logger.debug('feedback threshold: {}'.format(threshold))

        ratings = self.factory.get_datasource().ratings

        logger.info('process good ratings')
        # TODO: ratingsのquestionとquestion_answersのquestionを区別する
        good_ratings = ratings.with_good_by_bot(self.bot.id)
        if len(good_ratings) > 0:
            good_ratings = self._get_similarity_from_rating(good_ratings, query_vector)
            logger.info('feedback to query')
            good_ratings = good_ratings[good_ratings['similarity'] > threshold]
            logger.debug('good ratings count: {}'.format(len(good_ratings)))
            if len(good_ratings) > 0:
                good_rating_vectors = self._transform_texts_to_vector(good_ratings['original_question'])
                logger.debug(good_rating_vectors.shape)
                self.factory.feedback.fit_for_good(good_rating_vectors, good_ratings['question_answer_id'])

        logger.info('process bad ratings')
        bad_ratings = ratings.with_bad_by_bot(self.bot.id)
        if len(bad_ratings) > 0:
            bad_ratings = self._get_similarity_from_rating(bad_ratings, query_vector)

            logger.info('feedback to query')
            bad_ratings = bad_ratings[bad_ratings['similarity'] > threshold]
            logger.debug('bad ratings count: {}'.format(len(bad_ratings)))
            if len(bad_ratings) > 0:
                bad_rating_vectors = self._transform_texts_to_vector(bad_ratings['original_question'])
                logger.debug(bad_rating_vectors.shape)
                self.factory.feedback.fit_for_bad(bad_rating_vectors, bad_ratings['question_answer_id'])

        logger.info('reflect feedback')
        reflected_features = self.factory.feedback.transform_query_vector(query_vector)

        return reflected_features

    def _get_similarity_from_rating(self, data_frame, query_vector):
        vectors = self._transform_texts_to_vector(data_frame['question'])

        similarities = cosine_similarity(vectors, query_vector)
        similarities = similarities.flatten()
        data_frame['similarity'] = similarities
        return data_frame

    def _transform_texts_to_vector(self, texts):
        tokenized_sentences = self.factory.get_tokenizer().tokenize(texts)
        vectorized_features = self.factory.get_vectorizer().transform(tokenized_sentences)
        reduced_features = self.factory.get_reducer().transform(vectorized_features)
        normalized_features = self.factory.get_normalizer().transform(reduced_features)

        return normalized_features
