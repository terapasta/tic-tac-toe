import numpy as np
from sklearn import cross_validation
from sklearn.cross_validation import ShuffleSplit

class Evaluator:

    def evaluate(self, estimator, X, y):
        cv = ShuffleSplit(X.shape[0], n_iter=10, test_size=0.2, random_state=0)
        self.accuracy = np.mean(cross_validation.cross_val_score(estimator, X, y, cv=cv))
        self.precision = np.mean(cross_validation.cross_val_score(estimator, X, y, cv=cv, scoring='precision_macro'))
        self.recall = np.mean(cross_validation.cross_val_score(estimator, X, y, cv=cv, scoring='recall_macro'))
        self.f1 = np.mean(cross_validation.cross_val_score(estimator, X, y, cv=cv, scoring='f1_macro'))
        print('accuracy:', self.accuracy)
        print('precision:', self.precision)
        print('recall:', self.recall)
        print('f1:', self.f1)
