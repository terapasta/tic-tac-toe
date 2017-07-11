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
        datasource = Datasource(datasource_type)

        text_array = TextArray(X, vectorizer=self.vectorizer)
        logger.debug('Reply#perform text_array.separated_sentences: %s' % text_array.separated_sentences)
        features = text_array.to_vec()
        logger.debug('Reply#perform features: %s' % features)
        count = np.count_nonzero(features.toarray())

        if self.learning_parameter.use_similarity_classification:
            question_answers_ids, probabilities = self.__search_simiarity(X[0], datasource_type)
        else:
            # TODO: answerをquestion_answerに置き換える
            answer_ids, probabilities, question_answers_ids = self.__predict(features, X[0])

        reply_result = ReplyResult(question_answers_ids, probabilities, X[0], count)
        reply_result.out_log_of_results()
        return reply_result

    def __predict(self, features, question):
        similarity = Similarity(self._bot_id)
        # answers = self.estimator.predict(features)
        probabilities = self.estimator.predict_proba(features)
        answer_ids = self.estimator.classes_
        question_answers_ids = similarity.question_answers(question).to_data()
        return answer_ids, probabilities[0], question_answers_ids

    def __search_simiarity(self, question, datasource_type):
        """質問文間でコサイン類似度を算出して、近い質問文の候補を取得する
        """
        question_answer_ids, similarities = Similarity(self._bot_id).learning_training_messages(question, datasource_type=datasource_type, for_suggest=False).to_data_frame()
        return question_answer_ids, similarities
