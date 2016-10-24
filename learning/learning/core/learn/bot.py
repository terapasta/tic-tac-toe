# -*- coding: utf-8 -
import dataset
import numpy as np
import pandas as pd
import MySQLdb
from learning.log import logger
from sklearn.svm import SVC
from sklearn.grid_search import GridSearchCV
from sklearn.cross_validation import KFold
from sklearn.externals import joblib
from sklearn import linear_model
from sklearn.metrics import classification_report
from sklearn.metrics import precision_recall_fscore_support
from sklearn import cross_validation
from learning.core.evaluator import Evaluator
from learning.config.config import Config
from learning.core.training_set.training_message import TrainingMessage
# from ..plotter import Plotter


class Bot:
    def __init__(self, bot_id):
        self.bot_id = bot_id

    def learn(self):
        logger.debug('Bot.learn start')

        dbconfig = Config().get('database')
        db = dataset.connect(dbconfig['endpoint'])
        mysqldb = MySQLdb.connect(host=dbconfig['host'], db=dbconfig['name'], user=dbconfig['user'], passwd=dbconfig['password'], charset='utf8')
        training_set = TrainingMessage(db, mysqldb, self.bot_id)
        training_set.build()

        estimator = linear_model.LogisticRegression(C=1e5)
        estimator.fit(training_set.x, training_set.y)
        logger.debug(estimator.score(training_set.x, training_set.y))

        joblib.dump(estimator, "learning/models/%s_logistic_reg_model" % self.bot_id)
        # test_scores_mean = Plotter().plot(estimator, training_set.x, training_set.y)

        evaluator = Evaluator()
        # evaluator.evaluate(estimator, training_set.x, training_set.y)
        # クロスバリデーションではなく既存データに対して評価する
        evaluator.evaluate_using_exist_data(estimator, training_set.x, training_set.y)

        logger.debug('分類に失敗したデータのインデックス(bot.learning_training_messages[index]で参照出来る): %s' % evaluator.indexes_of_failed(estimator, training_set.x, training_set.y))
        logger.debug('Bot.learn end')


        return evaluator
