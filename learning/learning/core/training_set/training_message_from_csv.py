import numpy as np
import pandas as pd
from .base import Base
from learning.core.training_set.text_array import TextArray
from learning.log import logger

class TrainingMessageFromCsv(Base):
    def __init__(self, bot_id, file_path, learning_parameter, encoding='UTF-8'):
        self._file_path = file_path
        self._encoding = encoding
        self._bot_id = bot_id
        self._learning_parameter = learning_parameter

    def build(self):
        learning_training_messages = self.__build_learning_training_messages()
        questions = learning_training_messages['question']
        questions = questions.append(pd.Series(['', '', '']))

        body_array = TextArray(questions)
        # excepted_indexes = body_array.except_blank()
        x = body_array.to_vec()

        # logger.debug("x.toarray(): %s" % x.toarray())

        answer_ids = np.array(learning_training_messages['answer_id'])
        answer_ids = np.append(answer_ids, [0,0,0])
        # answer_ids = np.delete(answer_ids, excepted_indexes)

        self._body_array = body_array
        self._x = x
        self._y = answer_ids
        return self

    @property
    def body_array(self):
        return self._body_array

    def __build_learning_training_messages(self):
        data = pd.read_csv(self._file_path, encoding=self._encoding)
        logger.debug("TrainingMessageFromCsv#__build_learning_training_messages count of learning data: %s" % data['id'].count())
        return data