import numpy as np
import pandas as pd

from learning.core.predict.reply import Reply
from .base import Base
from learning.core.training_set.text_array import TextArray
from learning.log import logger

class TrainingMessage(Base):

    def __init__(self, datasource, bot_id, learning_parameter):
        logger.debug('TrainingMessage#__init__ start')
        self._datasource = datasource
        self._bot_id = bot_id
        self.learning_parameter = learning_parameter

    def build(self):
        logger.debug('TrainingMessage#build start')
        learning_training_messages = self._datasource.learning_training_messages(self._bot_id)
        questions = np.array(learning_training_messages['question'])
        question_answer_ids = np.array(learning_training_messages['question_answer_id'], dtype=np.int)

        # 空のテキストにラベル0を対応付けるために強制的にトレーニングセットを追加
        questions = np.append(questions, [''] * self.COUNT_OF_APPEND_BLANK)
        question_answer_ids = np.append(question_answer_ids, [Reply.CLASSIFY_FAILED_ANSWER_ID] * self.COUNT_OF_APPEND_BLANK)

        if self.learning_parameter.vectorize_using_all_bots:
            vectorizer = self.__build_vectorizer_from_all_bots()
        else:
            vectorizer = None

        body_array = TextArray(questions, vectorizer=vectorizer)
        body_vec = body_array.to_vec()

        self._body_array = body_array
        self._x = body_vec
        self._y = question_answer_ids
        return self

    def __build_vectorizer_from_all_bots(self):
        '''
            利用可能な全Botの学習セットを使用するように指定された場合、
            全Botの学習セットを使用してVectorizerを生成
        '''
        all_learning_training_messages = self._datasource.all_learning_training_messages()
        all_questions = np.array(all_learning_training_messages['question'])
        all_body_array = TextArray(all_questions)
        _ = all_body_array.to_vec()
        vectorizer = all_body_array.vectorizer

        return vectorizer

    @property
    def body_array(self):
        return self._body_array
