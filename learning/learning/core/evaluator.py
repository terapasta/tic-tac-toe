import numpy as np
from learning.log import logger
from sklearn import cross_validation
from sklearn.cross_validation import ShuffleSplit
from sklearn.metrics import precision_recall_fscore_support

class Evaluator:

    def evaluate(self, estimator, X, y):
        cv = ShuffleSplit(X.shape[0], n_iter=10, test_size=0.2, random_state=0)
        self.accuracy = np.mean(cross_validation.cross_val_score(estimator, X, y, cv=cv))
        self.precision = np.mean(cross_validation.cross_val_score(estimator, X, y, cv=cv, scoring='precision_macro'))
        self.recall = np.mean(cross_validation.cross_val_score(estimator, X, y, cv=cv, scoring='recall_macro'))
        self.f1 = np.mean(cross_validation.cross_val_score(estimator, X, y, cv=cv, scoring='f1_macro'))
        __out_log()

    def evaluate_using_exist_data(self, estimator, X, y):
        y_pred = estimator.predict(X)
        self.accuracy = estimator.score(X, y)

        scores = precision_recall_fscore_support(y, y_pred, average='macro')
        self.precision = scores[0]
        self.recall = scores[1]
        self.f1 = scores[2]
        self.__out_log()

    def __out_log(self):
        logger.debug('accuracy: %s' % self.accuracy)
        logger.debug('precision: %s' % self.precision)
        logger.debug('recall: %s' % self.recall)
        logger.debug('f1: %s' % self.f1)
