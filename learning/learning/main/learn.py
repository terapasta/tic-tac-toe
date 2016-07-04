# -*- coding: utf-8 -
import dataset
import numpy as np
from sklearn.svm import SVC
from sklearn.grid_search import GridSearchCV
from sklearn.cross_validation import KFold
from sklearn.externals import joblib
from ..core.training_set.training_message import TrainingMessage
from ..core.plotter import Plotter

db = dataset.connect('mysql://root@localhost/donusagi_bot')
training_set = TrainingMessage(db).build()

# 学習する
svm_tuned_parameters = [
    {
        # 'kernel': ['rbf'],
        # 'gamma': [2**n for n in range(-5, 3)],  # TODO 開発中はgridsearchの試行数を減らす
        # 'C': [2**n for n in range(-5, 8)]
        'kernel': ['rbf', 'linear'],
        'gamma': [2**n for n in range(-15, 3)],
        'C': [2**n for n in range(-5, 15)]
    }
]
gscv = GridSearchCV(
    SVC(),
    svm_tuned_parameters,
    cv=2,
    #cv=KFold(n=3),
    n_jobs = 1,
    verbose = 3
)

# print training_set[:,:-1]
# print training_set[:,-1:].flatten()
#
# gscv.fit(training_set[:,:-1], training_set[:,-1:].flatten())  # HACK training_setをオブジェクトにしたい
# svm_model = gscv.best_estimator_
#
# print training_set
# print(str(len(training_set)) + "件のトレーニングセットを学習しました")
# print svm_model  # 高パフォーマンスの学習モデル
# print gscv.best_params_  # 高パフォーマンスのパラメータ(gamma,Cの値)
#
# # 学習済みモデルをdumpする
# joblib.dump(svm_model, "learning/models/svm_model")
#
# # TODO データが少なすぎると落ちるので一旦コメントアウト
# Plotter().plot(svm_model, training_set[:,:-1], training_set[:,-1:].flatten())
