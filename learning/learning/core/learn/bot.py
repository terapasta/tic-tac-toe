import MySQLdb
from sklearn.grid_search import GridSearchCV

from learning.log import logger
from sklearn.externals import joblib
from sklearn.linear_model import LogisticRegression
from sklearn.naive_bayes import MultinomialNB
from learning.core.evaluator import Evaluator
from learning.config.config import Config
from learning.core.training_set.training_message import TrainingMessage
from learning.core.learn.learning_parameter import LearningParameter
from learning.core.persistance import Persistance

class Bot:
    def __init__(self, bot_id, learning_parameter):
        self.bot_id = bot_id
        self.learning_parameter = learning_parameter
        logger.debug('learning_parameter: %s' % vars(learning_parameter))

    def learn(self):
        logger.debug('Bot.learn start')
        config = Config()
        dbconfig = config.get('database')
        db = MySQLdb.connect(host=dbconfig['host'], db=dbconfig['name'], user=dbconfig['user'], passwd=dbconfig['password'], charset='utf8')
        training_set = TrainingMessage(db, self.bot_id, self.learning_parameter)
        training_set.build()

        estimator = self.__get_estimator(training_set)

        Persistance.dump_model(estimator, self.bot_id)
        Persistance.dump_vectorizer(training_set.body_array.vectorizer, self.bot_id)
        # test_scores_mean = Plotter().plot(estimator, training_set.x, training_set.y)

        evaluator = Evaluator()
        evaluator.evaluate(estimator, training_set.x, training_set.y)
        logger.debug('Bot.learn end')

        return evaluator

    def __get_estimator(self, training_set):
        # SVMのグリッドサーチに時間がかかるので、一旦ロジスティック回帰のみにする
        # estimator = self.__get_best_estimator(training_set)
        # estimator = self.__logistic_regression(training_set).best_estimator_
        # SVMを使用する
        # estimator = self.__svm(training_set).best_estimator_

        if self.learning_parameter.algorithm == LearningParameter.ALGORITHM_NAIVE_BAYES:
            logger.debug('use algorithm: naive bayes')
            estimator = MultinomialNB()
            # estimator = MultinomialNB(fit_prior=False)
            # estimator = BernoulliNB()
            estimator.fit(training_set.x, training_set.y)
        else:
            logger.debug('use algorithm: logistic regression')
            # estimator = LogisticRegression(C=1e5)
            # estimator = LogisticRegression()
            # estimator.fit(training_set.x, training_set.y)
            params = {'C': [0.001, 0.01, 0.1, 1, 10, 100, 140, 200]}
            grid = GridSearchCV(LogisticRegression(), param_grid=params)
            grid.fit(training_set.x, training_set.y)
            estimator = grid.best_estimator_
            logger.debug('best_params_: %s' % grid.best_params_)

        return estimator

    # def __get_best_estimator(self, training_set):
    #     grid_logi = self.__logistic_regression(training_set)
    #     grid_svm = self.__svm(training_set)
    #     if grid_logi.best_score_ > grid_svm.best_score_:
    #         logger.debug('採用するアルゴリズム: ロジスティック回帰')
    #         return grid_logi.best_estimator_
    #     else:
    #         logger.debug('採用するアルゴリズム: SVM')
    #         return grid_svm.best_estimator_


    # def __logistic_regression(self, training_set):
    #     param_grid = {'C': [0.0001, 0.001, 0.01, 0.1, 1, 10, 100, 1000] }
    #     grid = GridSearchCV(
    #         LogisticRegression(penalty='l2'),
    #         param_grid,
    #         # verbose=3
    #     )
    #     # grid = GridSearchCV(
    #     #     cv=None,
    #     #     estimator=LogisticRegression(
    #     #         C=1.0, intercept_scaling=1, dual=False, fit_intercept=True,
    #     #         penalty='l2', tol=0.0001),
    #     #     param_grid={'C': [0.001, 0.01, 0.1, 1, 10, 100, 1000]},
    #     #     verbose=3
    #     # )
    #     grid.fit(training_set.x, training_set.y)
    #     # estimator = grid.best_estimator_
    #
    #     # 単純なロジスティック回帰モデル
    #     # estimator = LogisticRegression(C=1e5)
    #     # estimator.fit(training_set.x, training_set.y)
    #     return grid

    # def __svm(self, training_set):
    #     svm_tuned_parameters = [
    #         {
    #             'kernel': ['rbf', 'linear'],
    #             # 'gamma': [2**n for n in range(-15, 3)],
    #             # 'C': [2**n for n in range(-5, 15)]
    #             'gamma': [2**n for n in range(-5, 3)],  # 開発中はgridsearchの試行数を減らす
    #             'C': [2**n for n in range(-5, 8)]
    #         }
    #     ]
    #     gscv = GridSearchCV(
    #         SVC(probability=True),
    #         svm_tuned_parameters,
    #         cv=2,
    #         #cv=KFold(n=3),
    #         n_jobs = 1,
    #         # verbose = 3
    #     )
    #     gscv.fit(training_set.x, training_set.y)
    #     return gscv
