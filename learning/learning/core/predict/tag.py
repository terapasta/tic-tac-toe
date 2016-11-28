from learning.log import logger
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.externals import joblib
from learning.core.nlang import Nlang
from learning.core.predict.model_not_exists_error import ModelNotExistsError
from learning.config.config import Config
from learning.core.training_set.training_text import TrainingText
from learning.core.training_set.text_array import TextArray

class Tag:

    def __init__(self):
        config = Config()
        try:
            self.estimator = joblib.load("learning/models/%s/tag_model" % config.env)
            self.vocabulary = joblib.load("learning/models/%s/tag_vocabulary.pkl" % config.env)
            self.binarizer = joblib.load("learning/models/%s/tag_model_labels.pkl" % config.env)
        except IOError:
            raise ModelNotExistsError()
#
    def predict(self, X):
        if len(X) == 0:
            return []
        body_array = TextArray(X, vocabulary=self.vocabulary)
        result = self.estimator.predict(body_array.to_vec())
        result = self.binarizer.inverse_transform(result)
        logger.debug("result: %s" % result)
        return result

    def binarize(self, tag_ids):
        return self.binarizer.transform(tag_ids)
