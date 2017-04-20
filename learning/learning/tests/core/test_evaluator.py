from unittest import TestCase
from nose.tools import ok_, eq_

import numpy as np
from sklearn.grid_search import GridSearchCV
from sklearn.linear_model import LogisticRegression

from learning.core.evaluator import Evaluator
from learning.core.learn.learning_parameter import LearningParameter
from learning.core.training_set.training_message_from_csv import TrainingMessageFromCsv

class EvaluatorTestCase(TestCase):
    def setUp(self):
        self.csv_file_path = 'learning/tests/fixtures/test_ptna_conversation.csv'
        self.bot_id = 9999

    def __get_estimator_and_training_set(self, learning_parameter):
        '''
            学習セットから分離させたいラベルを除外して予測
        '''
        training_set = TrainingMessageFromCsv(self.bot_id, self.csv_file_path, learning_parameter).build()
        indices_train, _ = training_set.indices_of_train_and_excluded_data(learning_parameter.excluded_labels_for_fitting)
        training_set_x = training_set.x[indices_train]
        training_set_y = training_set.y[indices_train]

        grid = GridSearchCV(LogisticRegression(), param_grid={'C': [100, 200]})
        grid.fit(training_set_x, training_set_y)
        estimator = grid.best_estimator_

        return estimator, training_set

    def test_normal_evaluate(self):
        attr = {
            'include_failed_data': False,
            'include_tag_vector': False,
            'classify_threshold': 0.5,
            'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION,
            'params_for_algorithm': {}
        }
        learning_parameter = LearningParameter(attr)
        estimator, training_set = self.__get_estimator_and_training_set(learning_parameter)

        '''
            通常のevaluateを実行しスコアを計測。
              accuracyだけが算出され、failure_scoreは算出されない
        '''
        evaluator = Evaluator()
        evaluator.evaluate(estimator, training_set.x, training_set.y, threshold=learning_parameter.classify_threshold)

        ok_(evaluator.accuracy > 0)
        ok_(evaluator.failure_score == 0)

    def test_no_exist_excluded_labels(self):
        attr = {
            'include_failed_data': False,
            'include_tag_vector': False,
            'classify_threshold': 0.5,
            'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION,
            'params_for_algorithm': {}
        }
        learning_parameter = LearningParameter(attr)
        estimator, training_set = self.__get_estimator_and_training_set(learning_parameter)

        '''
            evaluate_with_failure_scoreを実行し
            回答失敗になるスコアを計測。
              学習セットから分離させたいラベルが指定されていない場合
              accuracyだけが算出され、failure_scoreは算出されない
        '''
        evaluator = Evaluator()
        evaluator.evaluate_with_failure_score(estimator, training_set, learning_parameter)

        ok_(evaluator.accuracy > 0)
        ok_(evaluator.failure_score == 0)

    def test_exist_excluded_labels(self):
        attr = {
            'include_failed_data': False,
            'include_tag_vector': False,
            'classify_threshold': 0.5,
            'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION,
            'params_for_algorithm': {},
            'excluded_labels_for_fitting': [2708,2745,4630]
        }
        learning_parameter = LearningParameter(attr)
        estimator, training_set = self.__get_estimator_and_training_set(learning_parameter)

        '''
            evaluate_with_failure_scoreを実行し
            回答失敗になるスコアを計測。
              学習セットから分離させたいラベルが指定されている場合
              accuracyおよびfailure_scoreが算出される
        '''
        evaluator = Evaluator()
        evaluator.evaluate_with_failure_score(estimator, training_set, learning_parameter)

        ok_(evaluator.accuracy > 0)
        ok_(evaluator.failure_score > 0)