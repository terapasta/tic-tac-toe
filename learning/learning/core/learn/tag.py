import numpy as np
# import pandas as pd
import MySQLdb
from learning.log import logger
from learning.core.training_set.text_array import TextArray
from learning.core.training_set.training_text import TrainingText
from learning.core.nlang import Nlang
from learning.config.config import Config
# from sklearn.grid_search import GridSearchCV
# from sklearn.cross_validation import KFold
# from sklearn.externals import joblib
# from sklearn.linear_model import LogisticRegression
# from sklearn.grid_search import GridSearchCV
# from sklearn.metrics import classification_report
# from sklearn.metrics import precision_recall_fscore_support
# from sklearn import cross_validation
# from learning.core.evaluator import Evaluator
# from learning.core.training_set.training_message import TrainingMessage
# # from ..plotter import Plotter
from sklearn.svm import SVC
from sklearn.multiclass import OneVsRestClassifier
from sklearn.preprocessing import MultiLabelBinarizer
from sklearn.feature_extraction.text import CountVectorizer

class Tag:
    def __init__(self):
        logger.debug('Tag.__init__()')

    def learn(self):
        # TODO Dryにする
        config = Config()
        dbconfig = config.get('database')
        db = MySQLdb.connect(host=dbconfig['host'], db=dbconfig['name'], user=dbconfig['user'], passwd=dbconfig['password'], charset='utf8')

        c = OneVsRestClassifier(SVC(probability=True))
        training_set = TrainingText(db)
        training_set.build()

        logger.debug("training_set.x: %s" % training_set.x)
        logger.debug("training_set.y: %s" % training_set.y)

        binarizer = MultiLabelBinarizer().fit(training_set.y)
        binarized_y = binarizer.transform(training_set.y)
        logger.debug("binarized_y: %s" % binarized_y)
        estimator = c.fit(training_set.x, binarized_y)

        # predict
        count_vectorizer = CountVectorizer(vocabulary=training_set.body_array.vocabulary)
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


        result = estimator.predict_proba(feature_vectors)
        logger.debug(result)

        result = estimator.predict(feature_vectors)
        logger.debug(binarizer.inverse_transform(result))
