# -*- coding: utf-8 -
import logging
import numpy as np
import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.externals import joblib
from ..nlang import Nlang

class Reply:
    NO_CLASSIFIED_THRESHOLD = 0.2

    def __init__(self, bot_id):
        self.estimator = joblib.load("learning/models/%s_logistic_reg_model" % bot_id)
        #self.estimator = joblib.load("learning/models/svm_model")  # TODO 定数化したい
        self.vocabulary = joblib.load("learning/vocabulary/%s_vocabulary.pkl" % bot_id)

    def predict(self, X):
        Xtrain = np.array(X)
        Xtrain = self.__replace_text2vec(Xtrain)
        probabilities = self.estimator.predict_proba(Xtrain)
        max_probability = np.max(probabilities)
        if self.NO_CLASSIFIED_THRESHOLD > max_probability:
            return None
        return self.estimator.predict(Xtrain)[0]

    def __replace_text2vec(self, Xtrain):
        logging.basicConfig(filename="example.log",level=logging.DEBUG)
        #logging.debug('hogehoge2')
        #logging.debug(Xtrain)
        texts = Xtrain[:,-1:].flatten()
        splited_texts = Nlang.batch_split(texts)

        #logging.debug('hogehoge3')
        count_vectorizer = CountVectorizer(vocabulary=self.vocabulary)
        texts_vec = count_vectorizer.transform(splited_texts)
        texts_vec = texts_vec.toarray()

        feature = np.c_[Xtrain[:,:-1], texts_vec]
        feature = feature.astype('float64')
        return feature
