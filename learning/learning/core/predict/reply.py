import numpy as np
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity

from learning.core.datasource import Datasource
from learning.core.predict.model_not_exists_error import ModelNotExistsError
from learning.core.predict.reply_result import ReplyResult
from learning.core.persistance import Persistance
from learning.core.training_set.text_array import TextArray
from learning.log import logger
from learning.core.predict.similarity import Similarity


class Reply:
    CLASSIFY_FAILED_ANSWER_ID = 0

    def __init__(self, bot_id, learning_parameter):
        self.learning_parameter = learning_parameter
        self._bot_id = bot_id

        try:
            self.estimator = Persistance.load_model(bot_id)
            self.vectorizer = Persistance.load_vectorizer(bot_id)
        except IOError:
            raise ModelNotExistsError()

    def perform(self, X, datasource_type='database'):
        text_array = TextArray(self.vectorizer)
        features = text_array.to_vec(X)
        logger.debug('Reply#perform text_array.separated_sentences: %s' % text_array.separated_sentences)
        logger.debug('Reply#perform features: %s' % features)
        count = np.count_nonzero(features)

        learning_training_message_ids = None
        if self.learning_parameter.use_similarity_classification:
            question_answers_ids, probabilities, learning_training_message_ids = self.__search_simiarity(X[0], datasource_type)
        else:
            question_answers_ids, probabilities = self.__predict(features, X[0])

        reply_result = ReplyResult(question_answers_ids, probabilities, X[0], count, learning_training_message_ids)
        reply_result.out_log_of_results()
        return reply_result

    def __predict(self, features, question):
        # answers = self.estimator.predict(features)
        probabilities = self.estimator.predict_proba(features)
        question_answer_ids = self.estimator.classes_
        return question_answer_ids, probabilities[0]

    def __search_simiarity(self, question, datasource_type):
        """質問文間でコサイン類似度を算出して、近い質問文の候補を取得する
        """
        question_answer_ids, similarities, learning_training_message_ids = Similarity(self._bot_id).learning_training_messages(question, datasource_type=datasource_type, for_suggest=False).to_data_frame()
        return question_answer_ids, similarities, learning_training_message_ids,
