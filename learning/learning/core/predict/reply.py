import numpy as np
import dataset

from learning.core.predict.model_not_exists_error import ModelNotExistsError
from learning.core.predict.reply_result import ReplyResult
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
        self.answers = []
        self.probabilities = []

        try:
            self.estimator = Persistance.load_model(bot_id)
            self.vectorizer = Persistance.load_vectorizer(bot_id)
        except IOError:
            raise ModelNotExistsError()

    def perform(self, X):
        self.predict(X)
        reply_result = ReplyResult(self.answers, self.probabilities)
        return reply_result

        # TODO 近い質問を一覧を返す
        # reply.similarity_question_answer_ids(question)


    def predict(self, X):
        text_array = TextArray(X, vectorizer=self.vectorizer)
        features = text_array.to_vec()

        # タグベクトルを追加する処理
        # if self.learning_parameter.include_tag_vector:
        #     tag = Tag()
        #     tag_vec = tag.predict(Xtrain, return_type='binarized')
        #     features = np.c_[tag_vec, Xtrain_vec]

        self.answers = self.estimator.predict(features)
        self.probabilities = self.estimator.predict_proba(features)
        return self.answers

        # max_probability = np.max(probabilities)

        # for (question, answer, probabilities2) in zip(X, answers, probabilities):
        #     print('question: %s' % question)
        #     print('answer: %s' % answer)
        #     print('proba: %s \n' % max(probabilities2))
        #

    # TODO
    def similarity_question_answer_ids(self, question):
        return []