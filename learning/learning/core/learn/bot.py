# -*- coding: utf-8 -
import dataset
import numpy as np
import pandas as pd
import MySQLdb
from ... import log
from sklearn.svm import SVC
from sklearn.grid_search import GridSearchCV
from sklearn.cross_validation import KFold
from sklearn.externals import joblib
from sklearn import linear_model
from ..training_set.training_message import TrainingMessage
from ..plotter import Plotter
from ...config.config import Config

class Bot:
    def __init__(self, bot_id):
        self.bot_id = bot_id

    def learn(self):
        # logging.basicConfig(filename="example.log",level=logging.DEBUG)
        logger.debug('Bot.learn start')

        dbconfig = Config().get('database')
        db = dataset.connect(dbconfig['endpoint'])
        mysqldb = MySQLdb.connect(host=dbconfig['host'], db=dbconfig['name'], user=dbconfig['user'], passwd='', charset='utf8')
        training_set = TrainingMessage(db, mysqldb, self.bot_id)
        training_set.build()

        print(training_set.y)

        logger.debug('Bot.learn fit start')
        estimator = linear_model.LogisticRegression(C=1e5)
        estimator.fit(training_set.x, training_set.y)

        # print "estimator.score: %s " % estimator.score  # accuracy

        logger.debug('Bot.learn dump start')
        joblib.dump(estimator, "learning/models/%s_logistic_reg_model" % self.bot_id)
        test_scores_mean = Plotter().plot(estimator, training_set.x, training_set.y)
        logging.debug('Bot.learn end')
        return test_scores_mean
