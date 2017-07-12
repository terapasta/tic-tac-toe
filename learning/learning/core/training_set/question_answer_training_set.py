import numpy as np
import pandas as pd

from learning.core.training_set.base import Base
from learning.core.training_set.text_array import TextArray
from learning.log import logger

class QuestionAnserTrainingSet(Base):

    def __init__(self, db, bot_id):
        self.db = db
        self.bot_id = bot_id

    def build(self):
        question_answers = self.__question_answers()
        questions = np.array(question_answers['question'])
        ids = np.array(question_answers['id'])

        body_array = TextArray(questions)
        body_vec = body_array.to_vec()

        self._body_array = body_array
        self._x = body_vec
        self._y = ids
        return self

    @property
    def body_array(self):
        return self._body_array

    # HACK: datasourceに書きたい
    def __question_answers(self):
        data = pd.read_sql("select id, question from question_answers where bot_id = %s;" % self.bot_id, self.db)
        logger.debug('QuestionAnswerTrainingSet#__question_answers question_answers count: %s' % data['id'].count())
        return data