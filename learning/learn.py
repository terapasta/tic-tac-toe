from learning.core.learn.bot import Bot
# import dataset
# import numpy as np
# from sklearn.svm import SVC
# from sklearn.grid_search import GridSearchCV
# from sklearn.cross_validation import KFold
# from sklearn.externals import joblib
# from sklearn import linear_model
# from ..core.training_set.training_message import TrainingMessage
# from ..core.plotter import Plotter
# from ..config.config import Config
#
bot_id = 1
#
# db = dataset.connect(Config().get('database')['endpoint'])
# training_set = TrainingMessage(db, bot_id)
# training_set.build()
#
# estimator = linear_model.LogisticRegression(C=1e5)
# estimator.fit(training_set.x, training_set.y)
#
# print(training_set.y)
# # print "estimator.score: %s " % estimator.score  # accuracy
#
# joblib.dump(estimator, "learning/models/%s_logistic_reg_model" % bot_id)
#
# #Plotter().plot(estimator, training_set.x, training_set.y)  # TODO データが少ないと落ちる

evaluator = Bot(bot_id).learn()
