import numpy as np
import pandas as pd
import MySQLdb
from learning.log import logger
from sklearn.svm import SVC
from sklearn.grid_search import GridSearchCV
from sklearn.cross_validation import KFold
from sklearn.externals import joblib
from sklearn.linear_model import LogisticRegression
from sklearn.naive_bayes import MultinomialNB
from sklearn.grid_search import GridSearchCV
from sklearn.metrics import classification_report
from sklearn.metrics import precision_recall_fscore_support
from sklearn import cross_validation
from learning.core.evaluator import Evaluator
from learning.config.config import Config
from learning.core.training_set.training_message import TrainingMessage
# from ..plotter import Plotter


class Bot:
    def __init__(self, bot_id, learning_parameter):
        self.bot_id = bot_id
        self.learning_parameter = learning_parameter
        logger.debug("self.learning_parameter: % s" % self.learning_parameter)

    def learn(self):
        logger.debug('Bot.learn start')
        config = Config()
        dbconfig = config.get('database')
        db = MySQLdb.connect(host=dbconfig['host'], db=dbconfig['name'], user=dbconfig['user'], passwd=dbconfig['password'], charset='utf8')
        training_set = TrainingMessage(db, self.bot_id, self.learning_parameter)
        training_set.build()

        # SVMのグリッドサーチに時間がかかるので、一旦ロジスティック回帰のみにする
        # estimator = self.__get_best_estimator(training_set)
        # estimator = self.__logistic_regression(training_set).best_estimator_
        # シンプルなロジスティック回帰
        # estimator = LogisticRegression(C=1e5)
        # estimator.fit(training_set.x, training_set.y)
        # SVMを使用する
        # estimator = self.__svm(training_set).best_estimator_
        # ナイーブベイズを使用する
        estimator = MultinomialNB()
        estimator.fit(training_set.x, training_set.y)
        joblib.dump(training_set.body_array.vocabulary, "learning/models/%s/%s_vocabulary.pkl" % (config.env, self.bot_id))  # TODO dumpする処理はこのクラスの責務外なのでリファクタリングしたい
        joblib.dump(estimator, "learning/models/%s/%s_logistic_reg_model" % (config.env, self.bot_id))  # TODO ロジスティック回帰を使うとは限らないので修正したい
        # test_scores_mean = Plotter().plot(estimator, training_set.x, training_set.y)

        evaluator = Evaluator()
        evaluator.evaluate(estimator, training_set.x, training_set.y)
        # クロスバリデーションではなく既存データに対して評価する
        # evaluator.evaluate_using_exist_data(estimator, training_set.x, training_set.y)

        # logger.debug('分類に失敗したデータのインデックス(bot.learning_training_messages[index]で参照出来る): %s' % evaluator.indexes_of_failed(estimator, training_set.x, training_set.y))
        logger.debug('Bot.learn end')

        return evaluator

    def __get_best_estimator(self, training_set):
        grid_logi = self.__logistic_regression(training_set)
        grid_svm = self.__svm(training_set)
        if grid_logi.best_score_ > grid_svm.best_score_:
            logger.debug('採用するアルゴリズム: ロジスティック回帰')
            return grid_logi.best_estimator_
        else:
            logger.debug('採用するアルゴリズム: SVM')
            return grid_svm.best_estimator_


    def __logistic_regression(self, training_set):
        param_grid = {'C': [0.0001, 0.001, 0.01, 0.1, 1, 10, 100, 1000] }
        grid = GridSearchCV(
            LogisticRegression(penalty='l2'),
            param_grid,
            # verbose=3
        )
        # grid = GridSearchCV(
        #     cv=None,
        #     estimator=LogisticRegression(
        #         C=1.0, intercept_scaling=1, dual=False, fit_intercept=True,
        #         penalty='l2', tol=0.0001),
        #     param_grid={'C': [0.001, 0.01, 0.1, 1, 10, 100, 1000]},
        #     verbose=3
        # )
        grid.fit(training_set.x, training_set.y)
        # estimator = grid.best_estimator_

        # 単純なロジスティック回帰モデル
        # estimator = LogisticRegression(C=1e5)
        # estimator.fit(training_set.x, training_set.y)
        return grid

    def __svm(self, training_set):
        svm_tuned_parameters = [
            {
                'kernel': ['rbf', 'linear'],
                # 'gamma': [2**n for n in range(-15, 3)],
                # 'C': [2**n for n in range(-5, 15)]
                'gamma': [2**n for n in range(-5, 3)],  # FIXME 開発中はgridsearchの試行数を減らす
                'C': [2**n for n in range(-5, 8)]
            }
        ]
        gscv = GridSearchCV(
            SVC(),
            svm_tuned_parameters,
            cv=2,
            #cv=KFold(n=3),
            n_jobs = 1,
            # verbose = 3
        )
        gscv.fit(training_set.x, training_set.y)
        return gscv
