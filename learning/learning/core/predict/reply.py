import numpy as np
import pandas as pd
import dataset

from learning.core.predict.model_not_exists_error import ModelNotExistsError
from learning.core.predict.reply_result import ReplyResult
from learning.core.training_set.training_message import TrainingMessage
from learning.log import logger
from learning.config.config import Config
from learning.core.persistance import Persistance
from learning.core.training_set.text_array import TextArray
from sklearn.metrics.pairwise import cosine_similarity


class Reply:
    def __init__(self, bot_id, learning_parameter):
        config = Config()
        dbconfig = config.get('database')
        self.bot_id = bot_id
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
        similarity = self.similarity_question_answer_ids(X[0]) # TODO Xが1件のみしか対応できない
        # TODO similarityをreply_resultに含める
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

    def similarity_question_answer_ids(self, question):
        """質問文間でコサイン類似度を算出して、近い質問文の候補を取得する
        """
        question_answers = self.__all_question_answers()
        all_array = TextArray(question_answers['question'], vectorizer=self.vectorizer)
        # FIXME 1件のquestionのためにTextArrayクラスを使用するのは直感的ではない
        question_array = TextArray([question], vectorizer=self.vectorizer)

        similarities = cosine_similarity(all_array.to_vec(), question_array.to_vec())
        similarities = similarities.flatten()
        logger.debug("similarities: %s" % similarities)

        ordered_result = list(map(lambda x: {
            'question_answer_id': x[0], 'similarity': x[1]
        }, sorted(zip(question_answers['id'], similarities), key=lambda x: x[1], reverse=True)))
        return ordered_result

    def __all_question_answers(self):
        data = pd.read_sql("select id, question from question_answers where bot_id = %s;" % self.bot_id, self.db)
        return data