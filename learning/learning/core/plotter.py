# -*- coding: utf-8 -
import numpy as np
import matplotlib.pyplot as plt
from sklearn import cross_validation
from sklearn.naive_bayes import GaussianNB
from sklearn.svm import SVC
from sklearn.datasets import load_digits
from sklearn.learning_curve import learning_curve
from sklearn.cross_validation import ShuffleSplit

class Plotter:
    #def __init__(self):

    def plot(self, estimator, X, y):
        title = 'Learning Curves (SVM, xx kernel, $\gamma=%.6f$)' %estimator.gamma
        cv = ShuffleSplit(X.shape[0], n_iter=10, test_size=0.2, random_state=0)
        estimator = SVC(kernel=estimator.kernel, gamma=estimator.gamma, C=estimator.C)
        train_sizes, train_scores, test_scores = learning_curve(estimator, X, y, cv=cv)

        plt.figure()
        plt.title(title)
        #plt.ylim([0.7, 1.01])  # yの表示範囲
        plt.xlabel("Training examples")
        plt.ylabel("Score")

        train_scores_mean = np.mean(train_scores, axis=1)
        plt.plot(train_sizes, train_scores_mean, 'o-', color="r", label="Training score")

        test_scores_mean = np.mean(test_scores, axis=1)
        plt.plot(train_sizes, test_scores_mean, 'o-', color="g", label="Cross-validation score")

        plt.legend(loc="best")
        plt.plot(train_sizes, test_scores_mean, 'o-', color="g", label="Cross-validation score")
        plt.pause(15)


        # train_sizes = np.arange(40, int(len(y) * 0.6), 10)  # 等間隔数値の配列
        # cv = cross_validation.StratifiedKFold(y, n_folds=3, shuffle=True)
        # train_sizes, train_scores, test_scores = learning_curve(
        #     estimator, X, y, train_sizes=train_sizes, cv=cv)
        #
        # plt.figure()
        # plt.title('learning curve')
        # #plt.ylim([0.7, 1.01])  # yの表示範囲
        # plt.xlabel("Training examples")
        # plt.ylabel("Score")
        #
        # train_scores_mean = np.mean(train_scores, axis=1)
        # plt.plot(train_sizes, train_scores_mean, 'o-', color="r", label="Training score")
        #
        # test_scores_mean = np.mean(test_scores, axis=1)
        # plt.plot(train_sizes, test_scores_mean, 'o-', color="g", label="Cross-validation score")
        #
        # plt.legend(loc="best")
        # #plt.show()
        # plt.pause(10)
