# -*- coding: utf-8 -
import dataset
import numpy as np
from sklearn.svm import SVC
from sklearn.grid_search import GridSearchCV
from sklearn.cross_validation import KFold
from sklearn.externals import joblib
from ..core.feature.training_message import TrainingMessage

#
# from dataset import Dataset
# from feature_builder import FeatureBuilder
# # from predicter import Predicter
#
db = dataset.connect('mysql://root@localhost/donusagi_bot')
training_set = TrainingMessage(db).build()



# 学習する
svm_tuned_parameters = [
    {
        'kernel': ['rbf', 'linear'],
        'gamma': [2**n for n in range(-15, 3)],
        'C': [2**n for n in range(-5, 15)]
    }
]
gscv = GridSearchCV(
    SVC(),
    svm_tuned_parameters,
    #cv=2
    cv=KFold(n=3),
    n_jobs = 1,
    verbose = 3
)

print training_set[:,:-1]
print training_set[:,-1:].flatten()

gscv.fit(training_set[:,:-1], training_set[:,-1:].flatten())  # HACK training_setをオブジェクトにしたい
svm_model = gscv.best_estimator_

print svm_model  # 高パフォーマンスの学習モデル
print gscv.best_params_  # 高パフォーマンスのパラメータ(gamma,Cの値)

# 学習済みモデルをdumpする
joblib.dump(svm_model, "learning/models/svm_model")







# from sklearn import datasets
# from sklearn.cross_validation import train_test_split
# from sklearn.grid_search import GridSearchCV
# from sklearn.metrics import classification_report
# from sklearn.svm import SVC
# import numpy as np
# from sklearn.cross_validation import KFold
#
# X=np.array([[1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0,1,1,1,0,0,0,0,0], [1, 1, 1,1,0,0,0,1,0,0,1,1,1,1,0,1,0,0,0],[2,0,2,1,0,0,0,1,0,0,1,1,1,1,0,1,0,0,0], [3,1,3,2,0,0,1,1,0,0,0,1,1,1,0,0,0,1,0],[4,1,4,3,0,0,0,1,1,0,0,1,1,1,0,0,0,1,0], [4,1,5,1,0,1,0,1,0,0,0,1,1,0,0,0,0,0,0]])
# y = np.array([2,3,2,7,1,1])
#
# X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.5, random_state=0)
#
# tuned_parameters = [
#   {'C': [0.01, 0.03, 0.1, 0.3, 1, 3, 10, 30, 50, 70, 80, 90, 100], 'kernel': ['linear']},
#   {'C': [0.01, 0.03, 0.1, 0.3, 1, 3, 10, 30, 50, 70, 80, 90, 100], 'gamma': [0.001, 0.0001], 'kernel': ['rbf']},
#  ]
#
# #clf = GridSearchCV(SVC(C=1), tuned_parameters, cv=3)
# clf = GridSearchCV(SVC(C=1), tuned_parameters, cv=KFold(n=3))
#
# clf.fit(X_train, y_train)
