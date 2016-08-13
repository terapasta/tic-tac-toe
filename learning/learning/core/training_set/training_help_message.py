# -*- coding: utf-8 -
import MeCab
import numpy as np
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.externals import joblib
from ..nlang import Nlang
from .base import Base

class TrainingHelpMessage(Base):

    def __init__(self, db, bot_id):
        self.training_help_messages = db.query("select * from training_help_messages where bot_id = %s" % bot_id)
        self.bot_id = bot_id

    def build(self):
        splited_bodies = []
        help_answer_ids = []
        for training_help_message in self.training_help_messages:
            body = training_help_message['body']
            splited_bodies.append(Nlang.split(body))
            help_answer_ids.append(training_help_message['help_answer_id'])

        bodies_vec = Nlang.texts2vec(splited_bodies, 'learning/vocabulary/%s_helpdesk_vocabulary.pkl' % self.bot_id)
        feature = np.c_[bodies_vec.toarray(), np.array(help_answer_ids)]
        self._x = bodies_vec.toarray()
        self._y = np.array(help_answer_ids)
