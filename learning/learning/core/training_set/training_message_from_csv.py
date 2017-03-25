import numpy as np
import pandas as pd

from learning.core.predict.reply import Reply
from .base import Base
from learning.core.training_set.text_array import TextArray
from learning.log import logger

class TrainingMessageFromCsv(Base):
    COUNT_OF_APPEND_BLANK = 3

    def __init__(self, bot_id, file_path, learning_parameter, encoding='UTF-8'):
        self._file_path = file_path
        self._encoding = encoding
        self._bot_id = bot_id
        self._learning_parameter = learning_parameter

    def build(self):
        learning_training_messages = self.__build_learning_training_messages()
        questions = np.array(learning_training_messages['question'])
        answer_ids = np.array(learning_training_messages['answer_id'])

        # 空のテキストにラベル0を対応付けるために強制的にトレーニングセットを追加
        questions = np.append(questions, [''] * self.COUNT_OF_APPEND_BLANK)
        answer_ids = np.append(answer_ids, [Reply.CLASSIFY_FAILED_ANSWER_ID] * self.COUNT_OF_APPEND_BLANK)

        body_array = TextArray(questions)
        x = body_array.to_vec()

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