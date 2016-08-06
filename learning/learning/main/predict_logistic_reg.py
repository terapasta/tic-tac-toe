# -*- coding: utf-8 -
# import sys
# from sklearn.externals import joblib
# from predicter import Predicter
from ..core.predict.reply import Reply

X = [
    ['会社のミッションは？'],  # => 11
    ['ミッション'],  # => 11
    ['代表は誰？'],  # => 5
]
print(Reply().predict(X))

#
# sys.argv.pop(0)
# X = [sys.argv]
# print X
#
# svm_model = joblib.load("models/svm_model")
#vocabulary = joblib.load("vocabulary/vocabulary.pkl")
#
# predicter = Predicter(svm_model, vocabulary)
# result = predicter.predict(X)
#
# print result
# print result[0]
