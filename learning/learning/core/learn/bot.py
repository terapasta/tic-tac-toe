# -*- coding: utf-8 -
import dataset
import numpy as np
from sklearn.svm import SVC
from sklearn.grid_search import GridSearchCV
from sklearn.cross_validation import KFold
from sklearn.externals import joblib
from sklearn import linear_model
from ..training_set.training_message import TrainingMessage
from ..plotter import Plotter

class Bot:
    def learn(self):
        db = dataset.connect('mysql://root@localhost/donusagi_bot?charset=utf8')
        training_set = TrainingMessage(db).build()

        X = training_set[:,:-1] # HACK training_setをオブジェクトにしたい
        y = training_set[:,-1:].flatten()

        print y

        estimator = linear_model.LogisticRegression(C=1e5)
        estimator.fit(X, y)

        # print "estimator.score: %s " % estimator.score  # accuracy

        joblib.dump(estimator, "learning/models/logistic_reg_model")
        test_scores_mean = Plotter().plot(estimator, X, y)
        return test_scores_mean