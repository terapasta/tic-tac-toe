import numpy as np
from learning.log import logger
from learning.core.training_set.text_array import TextArray
from learning.core.training_set.training_text import TrainingText
from learning.core.nlang import Nlang
from learning.config.config import Config
from sklearn.externals import joblib
from sklearn.svm import SVC
from sklearn.multiclass import OneVsRestClassifier
from sklearn.preprocessing import MultiLabelBinarizer
from sklearn.feature_extraction.text import CountVectorizer
from learning.core.evaluator import Evaluator
from learning.core.database import Database

class Tag:
    def __init__(self):
        logger.debug('Tag.__init__()')

    def learn(self):
        config = Config()
        db = Database().connection
        c = OneVsRestClassifier(SVC(kernel='linear', probability=True))
        training_set = TrainingText(db)
        training_set.build()

        logger.debug("training_set.x: %s" % training_set.x)
        logger.debug("training_set.y: %s" % training_set.y)

        binarizer = MultiLabelBinarizer().fit(training_set.y)
        binarized_y = binarizer.transform(training_set.y)
        logger.debug("binarized_y: %s" % binarized_y)
        logger.debug("binarizer.classes_: %s" % binarizer.classes_)
        estimator = c.fit(training_set.x, binarized_y)

        # TODO pickleでバイナリにしてDBに保存したい(出来ればRails側で)
        joblib.dump(training_set.body_array.vocabulary, "learning/models/%s/tag_vocabulary.pkl" % config.env)
        joblib.dump(estimator, "learning/models/%s/tag_model" % config.env)
        joblib.dump(binarizer, "learning/models/%s/tag_model_labels.pkl" % config.env)

        evaluator = Evaluator()
        evaluator.evaluate(estimator, training_set.x, binarized_y)

        # predict
        # config = Config()
        # count_vectorizer = CountVectorizer(vocabulary=training_set.body_array.vocabulary)
        # splited_data = [
        #     Nlang.split('こんにちは'),
        #     Nlang.split('パソコンが壊れました。どうすればいいですか？'),
        #     Nlang.split('カードキーを自宅においてきてしまいました'),
        # ]
        # feature_vectors = count_vectorizer.fit_transform(splited_data)
        # result_proba = estimator.predict_proba(feature_vectors)
        # logger.debug("result_proba: %s" % result_proba)
        # result = estimator.predict(feature_vectors)
        # logger.debug("result: %s" % result)
        # logger.debug(binarizer.inverse_transform(result))

        # return None
