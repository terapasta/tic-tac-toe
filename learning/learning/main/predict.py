# -*- coding: utf-8 -
# import sys
# from sklearn.externals import joblib
# from predicter import Predicter
from ..core.predict.reply import Reply

X = [
    [0, 0, 0, 0, '最近調子どう？'],
    [0, 0, 0, 1, 'どんなサービスなの？'],
# #         [9, 10, 'お試し'],  # => 2
# #         [9, 10, '試せる？'],  # => 2
# #         [9, 10, '試してみたいんだけど'],  # => 2
# #         [9, 11, '無料なの？'],  # => 3
# #         [9, 11, '無料でいける？'],  # => 3
# #         [9, 11, '有料かな？'],  # => 3
# #         [9, 11, '他のサービス'],  # => 4
# #         [9, 12, 'どんな機能？'],  # => 5
# #         [9, 12, 'メリットは？'],  # => 5
]

print Reply().predict(X)

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