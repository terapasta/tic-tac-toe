# -*- coding: utf-8 -
import dataset
import numpy as np
from sklearn.svm import SVC
from sklearn.grid_search import GridSearchCV
from sklearn.cross_validation import KFold
from sklearn.externals import joblib
from sklearn import linear_model
from ..core.training_set.training_message import TrainingMessage
from ..core.plotter import Plotter
from ..config.config import Config

bot_id = 1

db = dataset.connect(Config().get('database')['endpoint'])
training_set = TrainingMessage(db, bot_id).build()

X = training_set[:,:-1] # HACK training_setをオブジェクトにしたい
y = training_set[:,-1:].flatten()

print(y)

estimator = linear_model.LogisticRegression(C=1e5)
estimator.fit(X, y)

# print "estimator.score: %s " % estimator.score  # accuracy

joblib.dump(estimator, "learning/models/%s_logistic_reg_model" % bot_id)

Plotter().plot(estimator, X, y)
