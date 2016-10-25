import numpy as np
import pandas as pd
import dataset
# import MySQLdb
from learning.log import logger
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.externals import joblib
from ..nlang import Nlang
from .model_not_exists_error import ModelNotExistsError
from learning.config.config import Config

class Reply:
    def __init__(self, bot_id):
        dbconfig = Config().get('database')
        self.db = dataset.connect(dbconfig['endpoint'])
        self.no_classified_threshold = Config().get('default_no_classified_threshold')

        try:
            self.estimator = joblib.load("learning/models/%s_logistic_reg_model" % bot_id)
            self.vocabulary = joblib.load("learning/vocabulary/%s_vocabulary.pkl" % bot_id) # TODO 定数化したい
        except IOError:
            raise ModelNotExistsError()

    def predict(self, X):
        Xtrain = np.array(X)
        Xtrain = self.__replace_text2vec(Xtrain)
        logger.debug('Xtrain: %s' % Xtrain)
        probabilities = self.estimator.predict_proba(Xtrain)
        max_probability = np.max(probabilities)

        logger.debug('no_classified_threshold: %s' % self.no_classified_threshold)
        logger.debug('max_probability: %s' % max_probability)
        if self.no_classified_threshold > max_probability:
            logger.debug('return None')
            return None

        answer_id = self.estimator.predict(Xtrain)[0]
        answers_table = self.db['answers']
        answer = answers_table.find_one(id=answer_id)
        logger.debug('予測された回答: %s' % answer['body'])
        logger.debug('予測確率: %s' % max_probability)

        learning_training_message = self.db['learning_training_messages'].find_one(answer_id=answer_id)
        question = np.array([[learning_training_message['question']]])
        logger.debug('question: %s' % question)
        question_vec = self.__replace_text2vec(question)
        logger.debug('question_vec: %s' % question_vec)

        result = np.logical_and(Xtrain[0], question_vec[0])
        # logger.debug('result: %s' % result)
        # result2 = filter((lambda x: x == True), result)
        # logger.debug('result2: %s' % result2)
        logger.debug(result.sum())
        if result.sum() < 3:
            logger.debug('質問のベクトル一致数が3未満の場合はNoneを返す')
            return None;

        return float(answer_id)


    def __replace_text2vec(self, Xtrain):
        texts = Xtrain[:,-1:].flatten()
        splited_texts = Nlang.batch_split(texts)
        logger.debug('分割後の文字列: %s' % splited_texts)

        count_vectorizer = CountVectorizer(vocabulary=self.vocabulary)
        texts_vec = count_vectorizer.transform(splited_texts)
        texts_vec = texts_vec.toarray()

        feature = np.c_[Xtrain[:,:-1], texts_vec]
        feature = feature.astype('float64')
        return feature
