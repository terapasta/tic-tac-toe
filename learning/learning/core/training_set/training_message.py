# -*- coding: utf-8 -
import MeCab
import numpy as np
import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.externals import joblib
from .base import Base
from learning.config.config import Config
from learning.core.training_set.text_array import TextArray

class TrainingMessage(Base):
    def __init__(self, db, bot_id):
        self.learning_training_messages = self.__build_training_data(db, bot_id)
        self.bot_id = bot_id

    def build(self):
        config = Config()
        self._body_array = TextArray(self.learning_training_messages['question'])
        self._x = self._body_array.to_vec()
        self._y = self.learning_training_messages['answer_id']

    @property
    def body_array(self):
        return self._body_array

    def __build_training_data(self, db, bot_id):
        data = pd.read_sql("select * from learning_training_messages where bot_id = %s;" % bot_id, db)
        data_count = data['id'].count()
        other_data = pd.read_sql("select * from learning_training_messages where bot_id <> %s order by rand() limit %s;" % (bot_id, data_count), db)
        # other_data['answer_id'] = 9999  # TODO 回答失敗のdeinfed_answersのIDを入れる
        # return pd.concat([data, other_data])
        return data
