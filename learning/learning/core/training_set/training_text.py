# import MeCab
# import numpy as np
import pandas as pd
# from sklearn.feature_extraction.text import CountVectorizer
# from sklearn.externals import joblib
from learning.core.training_set.base import Base
from learning.config.config import Config
from learning.core.training_set.text_array import TextArray
from learning.log import logger


class TrainingText(Base):

    def __init__(self, db):
        self.db = db
        self.training_texts = self.__build_training_texts()

    def build(self):
        config = Config()
        self._body_array = TextArray(self.training_texts['body'])
        self._x = self._body_array.to_vec()
        self._y = self.training_texts['tag_ids']

    @property
    def body_array(self):
        return self._body_array

    def __build_training_texts(self):
        data = pd.read_sql("select body, (SELECT GROUP_CONCAT(tag_id SEPARATOR ',') FROM taggings where taggable_id = training_texts.id and taggable_type = 'TrainingText') as tag_ids from training_texts", self.db)
        return data
