from sklearn.externals import joblib
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.preprocessing import MultiLabelBinarizer
from learning.core.nlang import Nlang
from learning.config.config import Config
from learning.log import logger

import MySQLdb
from learning.core.training_set.training_text import TrainingText

config = Config()
estimator = joblib.load("learning/models/%s/tag_model" % config.env)
vocabulary = joblib.load("learning/models/%s/tag_vocabulary.pkl" % config.env)
binarizer = joblib.load("learning/models/%s/tag_model_labels.pkl" % config.env)

count_vectorizer = CountVectorizer(vocabulary=vocabulary)
splited_data = [
    Nlang.split('こんにちは'),
    Nlang.split('パソコンが壊れました。どうすればいいですか？'),
    Nlang.split('パソコンが壊れちゃった。'),
]
feature_vectors = count_vectorizer.fit_transform(splited_data)

result = estimator.predict_proba(feature_vectors)
logger.debug(result)

result = estimator.predict(feature_vectors)
logger.debug(binarizer.inverse_transform(result))
