import numpy as np
import dataset

from learning.core.predict.model_not_exists_error import ModelNotExistsError
from learning.log import logger
from learning.config.config import Config
from learning.core.training_set.text_array import TextArray
from learning.core.persistance import Persistance

class Reply:
    def __init__(self, bot_id, learning_parameter):
        config = Config()
        dbconfig = config.get('database')
        self.db = dataset.connect(dbconfig['endpoint'])
        self.learning_parameter = learning_parameter

        try:
            self.estimator = Persistance.load_model(bot_id)
            self.vectorizer = Persistance.load_vectorizer(bot_id)
        except IOError:
            raise ModelNotExistsError()

    def perform(self, X):
        return self.predict(X)

    def predict(self, X):
        text_array = TextArray(X, vectorizer=self.vectorizer)
        features = text_array.to_vec()

        # タグベクトルを追加する処理
        # if self.learning_parameter.include_tag_vector:
        #     tag = Tag()
        #     tag_vec = tag.predict(Xtrain, return_type='binarized')
        #     features = np.c_[tag_vec, Xtrain_vec]

        answers = self.estimator.predict(features)
        probabilities = self.estimator.predict_proba(features)
        max_probability = np.max(probabilities)

        for (question, answer, probabilities2) in zip(X, answers, probabilities):
            print('question: %s' % question)
            print('answer: %s' % answer)
            print('proba: %s \n' % max(probabilities2))

        results_ordered_by_probability = list(map(lambda x: {
            'answer_id': float(x[0]), 'probability': x[1]
        }, sorted(zip(self.estimator.classes_, probabilities[0]), key=lambda x: x[1], reverse=True)))

        results = results_ordered_by_probability[0:10]
        self.__out_log_of_results(results)
        return results

    # TODO
    def similarity_question_answer_ids(self, question):
        return []

    def __out_log_of_results(self, results):
        logger.debug('predicted results (order by probability desc)')
        for result in results:
            logger.debug(result)