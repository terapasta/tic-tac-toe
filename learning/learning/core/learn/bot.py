from collections import Counter

import MySQLdb
from sklearn.grid_search import GridSearchCV

from learning.core.stop_watch import stop_watch
from learning.core.training_set.training_message_from_csv import TrainingMessageFromCsv
from learning.log import logger
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

    @stop_watch
    def learn(self, csv_file_path=None, csv_file_encoding='UTF-8'):
        logger.debug('start Bot#learn')

        training_set = self.__build_training_set(csv_file_path, csv_file_encoding)
        estimator = self.__get_estimator(training_set)
        logger.debug('after Bot#__get_estimator')

        Persistance.make_directory(self.bot_id)
        Persistance.dump_model(estimator, self.bot_id)
        Persistance.dump_vectorizer(training_set.body_array.vectorizer, self.bot_id)
        # test_scores_mean = Plotter().plot(estimator, training_set.x, training_set.y)

        evaluator = Evaluator()
        logger.debug('before Evaluator#evaluate')
        evaluator.evaluate_with_failure_score(estimator, training_set, self.learning_parameter)
        logger.debug('end Bot#learn')

        return evaluator

    def __build_training_set(self, csv_file_path, csv_file_encoding):
        config = Config()
        dbconfig = config.get('database')
        db = MySQLdb.connect(host=dbconfig['host'], db=dbconfig['name'], user=dbconfig['user'],
                             passwd=dbconfig['password'], charset='utf8')
        if csv_file_path is not None:
            training_set = TrainingMessageFromCsv(self.bot_id, csv_file_path, self.learning_parameter, encoding=csv_file_encoding)
        else:
            logger.debug('Bot after mysql connect')
            training_set = TrainingMessage(db, self.bot_id, self.learning_parameter)

        training_set.build()
        logger.debug('Bot#__build_training_set training_set.count_sample_by_y: %s' % training_set.count_sample_by_y())
        return training_set

    def __get_estimator(self, training_set):
        '''
            学習セットから分離させたいラベルが
            excluded_labels_for_fitting により指定されている場合、
            分離対象ラベルを学習セットから除外する
        '''
        indices_train, _ = training_set.indices_of_train_and_excluded_data(self.learning_parameter.excluded_labels_for_fitting)
        training_set_x = training_set.x[indices_train]
        training_set_y = training_set.y[indices_train]

        if self.learning_parameter.algorithm == LearningParameter.ALGORITHM_NAIVE_BAYES:
            logger.debug('use algorithm: naive bayes')
            estimator = MultinomialNB()
            # estimator = MultinomialNB(fit_prior=False)
            # estimator = BernoulliNB()
            estimator.fit(training_set_x, training_set_y)
        else:
            logger.debug('use algorithm: logistic regression')

            C = self.learning_parameter.params_for_algorithm.get('C', None)
            if C is None:
                logger.debug('learning_parameter has not parameter C')
                # params = {'C': [0.001, 0.01, 0.1, 1, 10, 100, 140, 200]}
                params = {'C': [10, 100, 140, 200]}
                # class_weight = self.__build_class_weight(training_set)
                # grid = GridSearchCV(LogisticRegression(class_weight=class_weight), param_grid=params)
                grid = GridSearchCV(LogisticRegression(), param_grid=params)
                grid.fit(training_set_x, training_set_y)
                estimator = grid.best_estimator_
                logger.debug('best_params_: %s' % grid.best_params_)
            else:
                logger.debug('learning_parameter has parameter C')
                estimator = LogisticRegression(C=C)
                estimator.fit(training_set_x, training_set_y)

        return estimator

    # # 不均衡データ対策
    # def __build_class_weight(self, training_set):
    #     counter = Counter(training_set.y)
    #     max_count = max(counter.values())
    #
    #     class_weight = {}
    #     for key, value in counter.most_common():
    #         class_weight[key] = max_count / value
    #
    #     logger.debug('Bot#__build_class_weight class_weight: %s' % class_weight)
    #     return class_weight

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
