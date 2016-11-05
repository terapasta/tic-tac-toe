# -*- coding: utf-8 -
import MeCab
import numpy as np
import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.externals import joblib
from ..nlang import Nlang
from .base import Base
from learning.config.config import Config

class TrainingMessage(Base):
    # TODO dbとmysqldbを統一したい
    def __init__(self, db, mysqldb, bot_id):
        self.learning_training_messages = pd.read_sql("select * from learning_training_messages where bot_id = %s;" % bot_id, mysqldb)
        self.bot_id = bot_id

    def build(self):
        config = Config()
        bodies = self.__split_bodies(self.learning_training_messages['question'])
        bodies_vec = Nlang.texts2vec(bodies, "learning/models/%s/%s_vocabulary.pkl" % (config.env, self.bot_id))  # TODO 定数化したい
        self._x = bodies_vec
        self._y = self.learning_training_messages['answer_id']

    def __split_bodies(self, bodies):
        splited_bodies = []
        for body in bodies:
            splited_bodies.append(Nlang.split(body))
        return splited_bodies
