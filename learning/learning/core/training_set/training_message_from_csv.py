import MeCab
import numpy as np
import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.externals import joblib
from .base import Base
from learning.config.config import Config
from learning.core.training_set.text_array import TextArray
from learning.log import logger
from learning.core.predict.tag import Tag

class TrainingMessageFromCsv(Base):
    def __init__(self, bot_id, csv_file_path, learning_parameter, csv_file_encoding='UTF-8'):
        self._csv_file_path = csv_file_path
        self._csv_file_encoding = csv_file_encoding
        self._bot_id = bot_id
        self._learning_parameter = learning_parameter
        # self.classfy_failed_answer_id = self.__find_classfy_failed_answer_id()

    def build(self):
        learning_training_messages = self.__build_learning_training_messages()
        body_array = TextArray(learning_training_messages['question'])
        x = body_array.to_vec(type='array')

        self._body_array = body_array
        self._x = x
        self._y = learning_training_messages['answer_id']
        logger.debug(self._x)

    @property
    def body_array(self):
        return self._body_array

    def __build_learning_training_messages(self):
        data = pd.read_csv(self._csv_file_path, encoding=self._csv_file_encoding)
        logger.debug("count of learning data: %s" % data['id'].count())
        return data