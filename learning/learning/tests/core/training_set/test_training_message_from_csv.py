from unittest import TestCase
from nose.tools import ok_, eq_

import numpy as np

from learning.core.learn.learning_parameter import LearningParameter
from learning.core.training_set.training_message_from_csv import TrainingMessageFromCsv

class TrainingMessageFromCsvTestCase(TestCase):
    def setUp(self):
        self.csv_file_path = 'learning/tests/fixtures/test_daikin_conversation.csv'
        self.bot_id = 9999

    def test_no_exist_excluded_labels(self):
        attr = {
            'include_failed_data': False,
            'include_tag_vector': False,
            'classify_threshold': 0.5,
            'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION,
            'params_for_algorithm': {}
        }
        learning_parameter = LearningParameter(attr)

        training_set = TrainingMessageFromCsv(self.bot_id, self.csv_file_path, learning_parameter)
        training_set.build()
        n_training_set = np.size(training_set.y) # 当初学習セットの件数
        indices_train, indices_excluded = training_set.indices_of_train_and_excluded_data(learning_parameter.excluded_labels_for_fitting)

        '''
            learning_parameter.excluded_labels_for_fittingを
            指定しなければ、全ての教師データが学習セットとなる。
            そのため、
              当初の学習セットとindices_trainの要素数が一致する
              indices_excludedの要素数は0
        '''
        eq_(np.size(indices_train), n_training_set)
        eq_(np.size(indices_excluded), 0)

    def test_exist_excluded_labels(self):
        attr = {
            'include_failed_data': False,
            'include_tag_vector': False,
            'classify_threshold': 0.5,
            'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION,
            'params_for_algorithm': {},
            'excluded_labels_for_fitting': [3400,3401,3402]
        }
        learning_parameter = LearningParameter(attr)

        training_set = TrainingMessageFromCsv(self.bot_id, self.csv_file_path, learning_parameter)
        training_set.build()
        n_training_set = np.size(training_set.y) # 当初学習セットの件数
        indices_train, indices_excluded = training_set.indices_of_train_and_excluded_data(learning_parameter.excluded_labels_for_fitting)

        y_excluded = training_set.y[indices_excluded]

        '''
            期待値
        '''
        expected_indices_excluded = np.array([
            3,     4,     5,   704,   705,   706,   707,  1155,  1156,
            1157,  1158,  1644,  1645,  1646,  1647,  1648,  1649,  1650,
            1651,  1652,  1653,  1654,  1655,  1656,  1657,  1658,  1659,
            1660,  1661,  1662,  1663,  1664,  1665,  1666,  1667,  1668,
            1669,  1670,  1671,  1672,  1673,  1674,  1675,  1676,  1677,
            1678,  1679,  1680,  1681,  1682,  1683,  1684,  1685,  1686,
            1687,  1688,  1689,  1690,  1691,  9215,  9216,  9217,  9218,
            9219,  9220,  9221,  9222,  9223,  9224,  9225,  9226,  9227,
            9228,  9229,  9230,  9231,  9232,  9233,  9234,  9235,  9236,
            9237,  9238,  9239,  9240,  9241,  9242,  9243,  9244,  9245,
            9246,  9247,  9248,  9249,  9250,  9251,  9252,  9253,  9254,
            9255,  9256,  9257,  9258,  9259,  9260,  9261,  9262, 16747,
            16748, 16749
        ])
        expected_y_excluded = np.array([
            3400, 3401, 3402, 3401, 3401, 3402, 3402, 3401, 3401, 3402, 3402,
            3400, 3400, 3400, 3400, 3400, 3400, 3400, 3400, 3400, 3400, 3400,
            3400, 3401, 3401, 3401, 3401, 3401, 3401, 3401, 3401, 3401, 3401,
            3401, 3401, 3401, 3401, 3401, 3401, 3401, 3401, 3402, 3402, 3402,
            3402, 3402, 3402, 3402, 3402, 3402, 3402, 3402, 3402, 3402, 3402,
            3402, 3402, 3402, 3402, 3400, 3400, 3400, 3400, 3400, 3400, 3400,
            3400, 3400, 3400, 3400, 3400, 3401, 3401, 3401, 3401, 3401, 3401,
            3401, 3401, 3401, 3401, 3401, 3401, 3401, 3401, 3401, 3401, 3401,
            3401, 3402, 3402, 3402, 3402, 3402, 3402, 3402, 3402, 3402, 3402,
            3402, 3402, 3402, 3402, 3402, 3402, 3402, 3402, 3400, 3401, 3402
        ])
        n_expected_excluded = np.size(expected_y_excluded)

        '''
            インデックス(indices_excluded)と
            除外ラベル(y_excluded)について、
            期待値と全て一致しているかどうかチェック
        '''
        eq_(n_expected_excluded, np.sum(indices_excluded == expected_indices_excluded))
        eq_(n_expected_excluded, np.sum(y_excluded == expected_y_excluded))

        '''
            indices_of_train_and_excluded_dataで得られた
            学習セット(indices_train) の件数をチェック
        '''
        n_expected_train_set = n_training_set - n_expected_excluded
        eq_(np.size(indices_train), n_expected_train_set)

    def test_blank_excluded_labels(self):
        attr = {
            'include_failed_data': False,
            'include_tag_vector': False,
            'classify_threshold': 0.5,
            'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION,
            'params_for_algorithm': {},
            'excluded_labels_for_fitting': []
        }
        learning_parameter = LearningParameter(attr)

        training_set = TrainingMessageFromCsv(self.bot_id, self.csv_file_path, learning_parameter)
        training_set.build()
        n_training_set = np.size(training_set.y) # 当初学習セットの件数
        indices_train, indices_excluded = training_set.indices_of_train_and_excluded_data(learning_parameter.excluded_labels_for_fitting)

        '''
            除外ラベルがないため、
              当初の学習セットとindices_trainの要素数が一致する
              indices_excludedの要素数は0
        '''
        eq_(np.size(indices_train), n_training_set)
        eq_(np.size(indices_excluded), 0)

    def test_nomatch_excluded_labels(self):
        attr = {
            'include_failed_data': False,
            'include_tag_vector': False,
            'classify_threshold': 0.5,
            'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION,
            'params_for_algorithm': {},
            'excluded_labels_for_fitting': [3333,3334,3335]
        }
        learning_parameter = LearningParameter(attr)

        training_set = TrainingMessageFromCsv(self.bot_id, self.csv_file_path, learning_parameter)
        training_set.build()
        n_training_set = np.size(training_set.y) # 当初学習セットの件数
        indices_train, indices_excluded = training_set.indices_of_train_and_excluded_data(learning_parameter.excluded_labels_for_fitting)

        '''
            該当する除外ラベルがないため、
              当初の学習セットとindices_trainの要素数が一致する
              indices_excludedの要素数は0
        '''
        eq_(np.size(indices_train), n_training_set)
        eq_(np.size(indices_excluded), 0)
