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
    CLASSIFY_FAILED_ID = 2

    def __init__(self, db, bot_id, learning_parameter):
        config = Config()
        self.db = db
        self.bot_id = bot_id
        self.learning_parameter = learning_parameter
        self.classfy_failed_answer_id = self.__find_classfy_failed_answer_id()

    def build(self, csv_file_path=None):
        learning_training_messages = self.__build_learning_training_messages(csv_file_path=csv_file_path)
        body_array = TextArray(learning_training_messages['question'])
        body_vec = body_array.to_vec(type='array')

        x = body_vec
        if self.learning_parameter.include_tag_vector:
            tag_vec = self.__extract_binarized_tag_vector(learning_training_messages)
            x = np.c_[tag_vec, body_vec]

        self._body_array = body_array
        self._x = x
        self._y = learning_training_messages['answer_id']
        logger.debug(self._x)

    @property
    def body_array(self):
        return self._body_array


    def __build_learning_training_messages(self, csv_file_path=None):
        if csv_file_path is not None:
            data = pd.read_csv(csv_file_path, encoding='SHIFT-JIS')
        else:
            data = pd.read_sql("select * from learning_training_messages where bot_id = %s;" % self.bot_id, self.db)

        if self.learning_parameter.include_failed_data:
            data_count = data['id'].count()
            other_data = pd.read_sql("select * from learning_training_messages where bot_id <> %s and char_length(question) > 10 order by rand() limit %s;" % (self.bot_id, data_count), self.db)
            other_data['answer_id'] = self.classfy_failed_answer_id
            data = pd.concat([data, other_data])
        logger.debug("data['id'].count(): %s" % data['id'].count())
        # data = pd.read_csv('prototype_id.csv', encoding='SHIFT-JIS')
        # logger.debug("data['question'].count(): %s" % data['question'].count())
        return data

    def __extract_binarized_tag_vector(self, learning_training_messages):
        tag_ids = learning_training_messages['tag_ids']
        tag_ids[tag_ids.isnull()] = ','
        tag_ids[tag_ids == ''] = ','
        tag_ids = tag_ids.str.split(':')
        logger.debug("tag_ids: %s" % list(tag_ids))

        try:
            logger.debug("self.binarizer.classes_: %s" % self.binarizer.classes_)
            tag_vector = self.binarizer.transform(tag_ids)
        except KeyError as e:
            logger.error('タグ学習時に存在していなかったタグが含まれている可能性があります。python learn_tag.pyを実行してください。')
            raise e

        logger.debug("tag_vector: %s" % tag_vector)
        return tag_vector

    def __find_classfy_failed_answer_id(self):
        cursor = self.db.cursor()
        cursor.execute("select id from answers where defined_answer_id = %s" % self.CLASSIFY_FAILED_ID)
        result = cursor.fetchone()
        if result is not None:
            return result[0]
        else:
            return None
