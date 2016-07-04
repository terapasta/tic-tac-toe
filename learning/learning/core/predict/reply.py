# -*- coding: utf-8 -
import logging
import numpy as np
import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.externals import joblib
from ..nlang import Nlang

class Reply:

    def __init__(self):
        self.estimator = joblib.load("learning/models/svm_model")  # TODO 定数化したい
        self.vocabulary = joblib.load("learning/vocabulary/vocabulary.pkl")

    def predict(self, X):
        #logging.basicConfig(filename="example.log",level=logging.DEBUG)
        #Xtrain = pd.Series(X)
        #logging.debug('hogehoge1')
        Xtrain = np.array(X)
        Xtrain = self.__replace_text2vec(Xtrain)
        #logging.debug('hogehoge5')
        return self.estimator.predict(Xtrain)

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

        logging.debug(splited_texts[0])
        logging.debug(texts_vec)

        feature = np.c_[Xtrain[:,:-1], texts_vec]
        return feature
