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

class TrainingMessage(Base):
    CLASSIFY_FAILED_ID = 2  # TODO Ruby側と重複管理

    def __init__(self, db, bot_id, learning_parameter):
        self.db = db
        self.bot_id = bot_id
        self.learning_parameter = learning_parameter
        self.classfy_failed_answer_id = self.__find_classfy_failed_answer_id()

    def build(self):
        config = Config()
        learning_training_messages = self.__build_learning_training_messages()
        tags = Tag().predict(learning_training_messages['question'])
        self._body_array = TextArray(learning_training_messages['question'])
        body_vec = self._body_array.to_vec(type='array')
        self._x = np.c_[tags, body_vec]
        self._y = learning_training_messages['answer_id']

        logger.debug('shapeの次元数')
        logger.debug(tags.shape)
        logger.debug(body_vec.shape)
        logger.debug(self._x.shape)

    @property
    def body_array(self):
        return self._body_array


    def __build_learning_training_messages(self):
        data = pd.read_sql("select * from learning_training_messages where bot_id = %s;" % self.bot_id, self.db)
        if self.learning_parameter.include_failed_data:
            data_count = data['id'].count()
            other_data = pd.read_sql("select * from learning_training_messages where bot_id <> %s and char_length(question) > 10 order by rand() limit %s;" % (self.bot_id, data_count), self.db)
            other_data['answer_id'] = self.classfy_failed_answer_id
            data = pd.concat([data, other_data])
            logger.debug("data['id'].count(): %s" % data['id'].count())
            return data


    def __find_classfy_failed_answer_id(self):
        cursor = self.db.cursor()
        cursor.execute("select id from answers where defined_answer_id = %s" % self.CLASSIFY_FAILED_ID)
        return cursor.fetchone()[0]
