import MySQLdb
import numpy as np
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity

from learning.core.predict.model_not_exists_error import ModelNotExistsError
from learning.core.predict.reply_result import ReplyResult
from learning.config.config import Config
from learning.core.persistance import Persistance
from learning.core.training_set.text_array import TextArray
from learning.log import logger


class Reply:
    CLASSIFY_FAILED_ANSWER_ID = 0

    def __init__(self, bot_id, learning_parameter):
        config = Config()
        dbconfig = config.get('database')
        self.db = MySQLdb.connect(host=dbconfig['host'], db=dbconfig['name'], user=dbconfig['user'],
                             passwd=dbconfig['password'], charset='utf8')
        self.bot_id = bot_id
        self.learning_parameter = learning_parameter
        # self.answers = []
        # self.probabilities = []

        try:
            self.estimator = Persistance.load_model(bot_id)
            self.vectorizer = Persistance.load_vectorizer(bot_id)
        except IOError:
            raise ModelNotExistsError()

    # def perform(self, X):
    #     text_array = TextArray(X, vectorizer=self.vectorizer)
    #     logger.debug('Reply#perform text_array.separated_sentences: %s' % text_array.separated_sentences)
    #     features = text_array.to_vec()
    #     logger.debug('Reply#perform features: %s' % features)
    #     count = np.count_nonzero(features.toarray())
    #
    #     # タグベクトルを追加する処理
    #     # if self.learning_parameter.include_tag_vector:
    #     #     tag = Tag()
    #     #     tag_vec = tag.predict(Xtrain, return_type='binarized')
    #     #     features = np.c_[tag_vec, Xtrain_vec]
    #
    #     # self.answers = self.estimator.predict(features)
    #     # self.probabilities = self.estimator.predict_proba(features)
    #     # self.answer_ids = self.estimator.classes_
    #
    #     df = self.question_answers(X[0])
    #
    #
    #     reply_result = ReplyResult(df['answer_id'], [df['similarity']], X[0], count)
    #     reply_result.out_log_of_results()
    #     return reply_result

    def perform(self, X):
        text_array = TextArray(X, vectorizer=self.vectorizer)
        logger.debug('Reply#perform text_array.separated_sentences: %s' % text_array.separated_sentences)
        features = text_array.to_vec()
        logger.debug('Reply#perform features: %s' % features)
        count = np.count_nonzero(features.toarray())

        if self.learning_parameter.use_similarity_classification:
            answer_ids, probabilities = self.__search_simiarity(X[0])
        else:
            answer_ids, probabilities = self.__predict(features)

        reply_result = ReplyResult(answer_ids, probabilities, X[0], count)
        reply_result.out_log_of_results()
        return reply_result

    def __predict(self, features):
        # answers = self.estimator.predict(features)
        probabilities = self.estimator.predict_proba(features)
        answer_ids = self.estimator.classes_
        return answer_ids, probabilities[0]

    def __search_simiarity(self, question):
        # TODO similarityクラスで共通化する
        """質問文間でコサイン類似度を算出して、近い質問文の候補を取得する
        """
        question_answers = self.__all_question_answers(question)
        all_array = TextArray(question_answers['question'], vectorizer=self.vectorizer)
        question_array = TextArray([question], vectorizer=self.vectorizer)

        similarities = cosine_similarity(all_array.to_vec(), question_array.to_vec())
        similarities = similarities.flatten()
        logger.debug("similarities: %s" % similarities)

        ordered_result = list(map(lambda x: {
            'question_answer_id': float(x[0]), 'similarity': x[1], 'answer_id': x[2]
        }, sorted(zip(question_answers['id'], similarities, question_answers['answer_id']), key=lambda x: x[1], reverse=True)))

        df = pd.DataFrame.from_dict(ordered_result)
        return df['answer_id'], df['similarity']

    # TODO similarityクラスで共通化する
    def __all_question_answers(self, question):
        data = pd.read_sql(
            "select id, question, answer_id from question_answers where bot_id = %s and question <> '%s' and answer_id <> %s;"
            % (self.bot_id, question, Reply.CLASSIFY_FAILED_ANSWER_ID), self.db)
        return data