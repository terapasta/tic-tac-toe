import numpy as np
import time

from learning.log import logger
from sklearn.cross_validation import ShuffleSplit
from sklearn.cross_validation import cross_val_score
from sklearn.metrics import precision_recall_fscore_support

class Evaluator:

    def __init__(self):
        self.accuracy = 0
        self.precision = 0
        self.recall = 0
        self.f1 = 0
        self.threshold = 0
        self.failure_score = 0

    def evaluate(self, estimator, X, y, threshold=0.0):
        threshold = 0.0 if threshold is None else threshold
        self.threshold = threshold
        logger.debug('self.threshold: %s' % self.threshold)
        start = time.time()

        cv = ShuffleSplit(X.shape[0], n_iter=1, test_size=0.25, random_state=0)
        self.accuracy = np.mean(cross_val_score(estimator, X, y, cv=cv, scoring=self.__accuracy_score))
        print(self.accuracy)
        # self.accuracy = np.mean(cross_val_score(estimator, X, y, cv=cv))

        # 実行時に警告が出るため一旦コメントアウト(今のところチューニングにもあまり使用していない)
        # self.precision = np.mean(cross_validation.cross_val_score(estimator, X, y, cv=cv, scoring='precision_macro'))
        # self.recall = np.mean(cross_validation.cross_val_score(estimator, X, y, cv=cv, scoring='recall_macro'))
        # self.f1 = np.mean(cross_validation.cross_val_score(estimator, X, y, cv=cv, scoring='f1_macro'))

        secs = time.time() - start
        msecs = secs * 1000
        logger.debug('Evaluator#evaluate#elapsed time: %f ms' % msecs)

        self.__out_log()

    def evaluate_with_failure_score(self, estimator, training_set, learning_parameter):
        '''
            学習セットから分離させたいラベルが
            excluded_labels_for_fitting により指定されている場合、
            分離対象ラベルを学習セットから除外後、accuracyを算出
        '''
        indices_train, indices_excluded = training_set.indices_of_train_and_excluded_data(learning_parameter.excluded_labels_for_fitting)
        X = training_set.x[indices_train]
        y = training_set.y[indices_train]

        threshold = learning_parameter.classify_threshold
        self.evaluate(estimator, X, y, threshold=threshold)

        '''
            学習セットから分離させたラベルにより予測し、
            正しく回答失敗となる確率を求める
            proba <= self.threshold なら回答失敗
        '''
        if np.size(indices_excluded) == 0:
            return

        X_excluded = training_set.x[indices_excluded]
        probabilities = estimator.predict_proba(X_excluded)
        max_probabilities = np.max(probabilities, axis=1)

        failure_score_threshold = self.threshold
        logger.debug('failure_score_threshold: %s' % failure_score_threshold)

        bools = (max_probabilities <= failure_score_threshold)
        self.failure_score = np.sum(bools) / np.size(bools, axis=0)
        logger.debug('failure score: %s' % self.failure_score)

    def evaluate_using_exist_data(self, estimator, X, y):
        y_pred = estimator.predict(X)
        self.accuracy = estimator.score(X, y)

        scores = precision_recall_fscore_support(y, y_pred, average='macro')
        self.precision = scores[0]
        self.recall = scores[1]
        self.f1 = scores[2]
        self.__out_log()

    def indexes_of_failed(self, estimator, X, y):
        y_pred = estimator.predict(X)
        indexes = []
        # TODO: answer_idの使用をやめる
        for i, answer_id in enumerate(y):
            if y[i] != y_pred[i]:
                indexes.append(i)
        return indexes

    def __out_log(self):
        logger.debug('accuracy: %s' % self.accuracy)
        # logger.debug('precision: %s' % self.precision)
        # logger.debug('recall: %s' % self.recall)
        # logger.debug('f1: %s' % self.f1)

    def __accuracy_score(self, estimator, X, y):
        y_pred = estimator.predict(X)
        probabilities = estimator.predict_proba(X)
        max_probabilities = np.max(probabilities, axis=1)

        # 予測結果と実際を比較
        bools = y == y_pred
        # しきい値を超えているもののみをTrueにする
        bools = bools == (max_probabilities > self.threshold)
        # 正当率を算出
        score = np.sum(bools) / np.size(bools, axis=0)
        return score
