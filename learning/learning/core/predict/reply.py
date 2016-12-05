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
from learning.core.predict.tag import Tag

class Reply:
    def __init__(self, bot_id):
        config = Config()
        dbconfig = config.get('database')
        self.db = dataset.connect(dbconfig['endpoint'])
        self.no_classified_threshold = config.get('default_no_classified_threshold')

        try:
            self.estimator = joblib.load("learning/models/%s/%s_logistic_reg_model" % (config.env, bot_id))
            self.vocabulary = joblib.load("learning/models/%s/%s_vocabulary.pkl" % (config.env, bot_id)) # TODO 定数化したい
        except IOError:
            raise ModelNotExistsError()

    def predict(self, X):
        # TODO TextArrayを使いたい
        Xtrain = np.array(X)
        Xtrain = Xtrain[:,-1:].flatten()
        Xtrain_vec = self.__replace_text2vec(Xtrain)
        logger.debug(Xtrain)

        tag = Tag()
        tag_vec = tag.predict(Xtrain, return_type='binarized')
        features = np.c_[tag_vec, Xtrain_vec]
        logger.debug("features: %s" % features)

        probabilities = self.estimator.predict_proba(features)
        max_probability = np.max(probabilities)

        results_ordered_by_probability = list(map(lambda x: {
            'answer_id': float(x[0]), 'probability': x[1]
        }, sorted(zip(self.estimator.classes_, probabilities[0]), key=lambda x: x[1], reverse=True)))

        logger.debug('results_ordered_by_probability: %s' % results_ordered_by_probability)
        logger.debug('no_classified_threshold: %s' % self.no_classified_threshold)
        logger.debug('max_probability: %s' % max_probability)
        # if self.no_classified_threshold > max_probability:
        #     logger.debug('return []')
        #     return []

        # answer_id = self.estimator.predict(Xtrain)[0]
        # self.__out_log(answer_id)

        return results_ordered_by_probability[0:10]
        # return float(answer_id)


    def __replace_text2vec(self, Xtrain):
        # texts = Xtrain[:,-1:].flatten()
        splited_texts = Nlang.batch_split(Xtrain)
        logger.debug('分割後の文字列: %s' % splited_texts)

        count_vectorizer = CountVectorizer(vocabulary=self.vocabulary)
        texts_vec = count_vectorizer.transform(splited_texts)
        texts_vec = texts_vec.toarray()

        # feature = np.c_[Xtrain[:,:-1], texts_vec]
        feature = texts_vec.astype('float64')
        return feature

    def __out_log(self, answer_id):
        answers_table = self.db['answers']
        answer = answers_table.find_one(id=answer_id)
        logger.debug('予測された回答ID: %s' % answer_id)
        if answer is not None:
            logger.debug('予測された回答: %s' % answer['body'])
