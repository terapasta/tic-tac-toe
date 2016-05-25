# -*- coding: utf-8 -
import numpy as np
import pandas as pd
from sklearn import cross_validation
from sklearn.svm import SVC
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.learning_curve import learning_curve
from data_parser import DataParser

class Predicter:

    def __init__(self, estimator, vocabulary):
        self.estimator = estimator
        self.vocabulary = vocabulary

    def predict(self, X):
        #print X
        data_parser = DataParser()
        Xtrain = pd.Series(X)
        input_texts = []
        for input_text in Xtrain:
          input_texts.append(data_parser.split(input_text.decode('utf-8')))

        count_vectorizer = CountVectorizer(
            vocabulary=self.vocabulary # 学習時の vocabulary を指定する
        )
        feature_vectors = count_vectorizer.fit_transform(input_texts)
        return self.estimator.predict(feature_vectors)
