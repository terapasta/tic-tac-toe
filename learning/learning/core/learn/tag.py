import numpy as np
# import pandas as pd
# import MySQLdb
from learning.log import logger
from learning.core.training_set.text_array import TextArray
from learning.core.nlang import Nlang
# from sklearn.svm import SVC
# from sklearn.grid_search import GridSearchCV
# from sklearn.cross_validation import KFold
# from sklearn.externals import joblib
# from sklearn.linear_model import LogisticRegression
# from sklearn.grid_search import GridSearchCV
# from sklearn.metrics import classification_report
# from sklearn.metrics import precision_recall_fscore_support
# from sklearn import cross_validation
# from learning.core.evaluator import Evaluator
# from learning.config.config import Config
# from learning.core.training_set.training_message import TrainingMessage
# # from ..plotter import Plotter
from sklearn.svm import SVC
from sklearn.multiclass import OneVsRestClassifier
from sklearn.preprocessing import MultiLabelBinarizer
from sklearn.feature_extraction.text import CountVectorizer

class Tag:
    def __init__(self):
        print('Tag()')
        # self.bot_id = bot_id
        # self.learning_parameter = learning_parameter
        # logger.debug("self.learning_parameter: % s" % self.learning_parameter)

    def learn(self):
        c = OneVsRestClassifier(SVC(probability=True))
        # X = [[1,0,0],[0,1,0],[0,0,1],[1,0,1],[1,1,1]]
        # Y = [[1],[2],[3],[1,2],[1,3]]


        # logger.debug('Tag.learn start')
        #
        # # {
        # #   1: greeting,
        # #   2: pc
        # #   3: buy
        # #   4: fail
        # #   5: question
        # #   6: password
        # #   7: key
        # #   8: forget
        # # }
        train_x = np.array([
            'こんにちは',
            'パソコンが壊れました。どうすればいいですか？',
            'パソコンを買いたいのですがどこで買おうかな？',
            'パスワードを忘れてしまいました',
            'カードキーを自宅においてきてしまいました',
        ])
        train_y = np.array([
            [1],
            [2,4,5],
            [2,3,5],
            [6,8],
            [7,8]
        ])
        #
        text_array = TextArray(train_x)
        # c = OneVsRestClassifier(SVC())
        # binarizer = MultiLabelBinarizer().fit(train_y)
        # train_y = binarizer.transform(train_y)
        # logger.debug("train_y: %s" % train_y)
        feature = text_array.to_vec()
        # logger.debug(feature.toarray())
        #
        # # feature = np.array([
        # #     [1,1,1,1],
        # #     [1,2,1,4],
        # #     [2,2,0,4],
        # #     [2,1,0,4],
        # #     [1,2,0,4],
        # # ])
        # estimator = c.fit(feature, train_y)
        #
        # predict
        count_vectorizer = CountVectorizer(vocabulary=text_array.vocabulary)
        splited_data = [
            Nlang.split('こんにちは'),
            Nlang.split('パソコンが壊れました。どうすればいいですか？'),
        ]
        feature_vectors = count_vectorizer.fit_transform(splited_data)
        # logger.debug("feature_vectors.torray(): %s" % feature_vectors.toarray())
        # result = estimator.predict(feature_vectors)
        # logger.debug("result: %s" % result)
        # # print(binarizer.inverse_transform(result))
        # # hoge = MultiLabelBinarizer().inverse_transform(result)
        # # print(hoge)

        binarizer = MultiLabelBinarizer().fit(train_y)
        yyy = binarizer.transform(train_y)
        estimator = c.fit(feature, yyy)

        result = estimator.predict_proba(feature_vectors)
        logger.debug(result)

        result = estimator.predict(feature_vectors)
        logger.debug(binarizer.inverse_transform(result))

#         config = Config()
#         dbconfig = config.get('database')
#         db = MySQLdb.connect(host=dbconfig['host'], db=dbconfig['name'], user=dbconfig['user'], passwd=dbconfig['password'], charset='utf8')
#         training_set = TrainingMessage(db, self.bot_id, self.learning_parameter)
#         training_set.build()
#
#         # SVMのグリッドサーチに時間がかかるので、一旦ロジスティック回帰のみにする
#         # estimator = self.__get_best_estimator(training_set)
#         # estimator = self.__logistic_regression(training_set).best_estimator_
#         # シンプルなロジスティック回帰
#         estimator = LogisticRegression(C=1e5)
#         estimator.fit(training_set.x, training_set.y)
#         # SVMを使用する
#         # estimator = self.__svm(training_set).best_estimator_
#         joblib.dump(training_set.body_array.vocabulary, "learning/models/%s/%s_vocabulary.pkl" % (config.env, self.bot_id))  # TODO dumpする処理はこのクラスの責務外なのでリファクタリングしたい
#         joblib.dump(estimator, "learning/models/%s/%s_logistic_reg_model" % (config.env, self.bot_id))
#         # test_scores_mean = Plotter().plot(estimator, training_set.x, training_set.y)
#
#         evaluator = Evaluator()
#         evaluator.evaluate(estimator, training_set.x, training_set.y)
#         # クロスバリデーションではなく既存データに対して評価する
#         # evaluator.evaluate_using_exist_data(estimator, training_set.x, training_set.y)
#
#         # logger.debug('分類に失敗したデータのインデックス(bot.learning_training_messages[index]で参照出来る): %s' % evaluator.indexes_of_failed(estimator, training_set.x, training_set.y))
#         logger.debug('Bot.learn end')
#
#         return evaluator
#
#     def __get_best_estimator(self, training_set):
#         grid_logi = self.__logistic_regression(training_set)
#         grid_svm = self.__svm(training_set)
#         if grid_logi.best_score_ > grid_svm.best_score_:
#             logger.debug('採用するアルゴリズム: ロジスティック回帰')
#             return grid_logi.best_estimator_
#         else:
#             logger.debug('採用するアルゴリズム: SVM')
#             return grid_svm.best_estimator_
#
#
#     def __logistic_regression(self, training_set):
#         param_grid = {'C': [0.0001, 0.001, 0.01, 0.1, 1, 10, 100, 1000] }
#         grid = GridSearchCV(
#             LogisticRegression(penalty='l2'),
#             param_grid,
#             # verbose=3
#         )
#         # grid = GridSearchCV(
#         #     cv=None,
#         #     estimator=LogisticRegression(
#         #         C=1.0, intercept_scaling=1, dual=False, fit_intercept=True,
#         #         penalty='l2', tol=0.0001),
#         #     param_grid={'C': [0.001, 0.01, 0.1, 1, 10, 100, 1000]},
#         #     verbose=3
#         # )
#         grid.fit(training_set.x, training_set.y)
#         # estimator = grid.best_estimator_
#
#         # 単純なロジスティック回帰モデル
#         # estimator = LogisticRegression(C=1e5)
#         # estimator.fit(training_set.x, training_set.y)
#         return grid
#
#     def __svm(self, training_set):
#         svm_tuned_parameters = [
#             {
#                 'kernel': ['rbf', 'linear'],
#                 # 'gamma': [2**n for n in range(-15, 3)],
#                 # 'C': [2**n for n in range(-5, 15)]
#                 'gamma': [2**n for n in range(-5, 3)],  # FIXME 開発中はgridsearchの試行数を減らす
#                 'C': [2**n for n in range(-5, 8)]
#             }
#         ]
#         gscv = GridSearchCV(
#             SVC(),
#             svm_tuned_parameters,
#             cv=2,
#             #cv=KFold(n=3),
#             n_jobs = 1,
#             # verbose = 3
#         )
#         gscv.fit(training_set.x, training_set.y)
#         return gscv
