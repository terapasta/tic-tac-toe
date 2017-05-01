import numpy as np
import pandas as pd
import os

from learning.core.predict.reply import Reply
from .base import Base
from learning.core.training_set.text_array import TextArray
from learning.log import logger

class TrainingMessageFromCsv(Base):

    def __init__(self, bot_id, file_path, external_vocabulary_csv_file_path, learning_parameter, encoding='UTF-8'):
        self._file_path = file_path
        self._encoding = encoding
        self._bot_id = bot_id
        self._learning_parameter = learning_parameter
        self._external_vocabulary_csv_file_path = external_vocabulary_csv_file_path

    def build(self):
        learning_training_messages = self.__build_learning_training_messages()
        questions = np.array(learning_training_messages['question'])
        answer_ids = np.array(learning_training_messages['answer_id'])

        # 空のテキストにラベル0を対応付けるために強制的にトレーニングセットを追加
        questions = np.append(questions, [''] * self.COUNT_OF_APPEND_BLANK)
        answer_ids = np.append(answer_ids, [Reply.CLASSIFY_FAILED_ANSWER_ID] * self.COUNT_OF_APPEND_BLANK)

        body_array = TextArray(questions)
        x = body_array.to_vec()
        y = answer_ids

        if self._learning_parameter.vectorize_using_all_bots == True:
            x, y = self.__extract_target_training_set(x, y)

        self._body_array = body_array
        self._x = x
        self._y = y
        return self

    @property
    def body_array(self):
        return self._body_array

    def __build_learning_training_messages(self):
        if self._learning_parameter.vectorize_using_all_bots:
            data = pd.read_csv(self._external_vocabulary_csv_file_path, encoding=self._encoding)
        else:
            data = pd.read_csv(self._file_path, encoding=self._encoding)

        logger.debug("TrainingMessageFromCsv#__build_learning_training_messages count of learning data: %s" % data['id'].count())
        return data

    def __extract_target_training_set(self, x, y):
        '''
            該当Botに関連づけられたデータのインデックスを取得し、
            該当Botに対応するTFIDF値／ラベルだけを抽出
        '''
        logger.debug("TrainingMessageFromCsv#__extract_target_training_set count(all): samples=%d, features=%d, labels=%d" % (
            x.shape[0], x.shape[1], np.size(np.unique(y))
        ))

        target_data = pd.read_csv(self._file_path, encoding=self._encoding)
        target_answer_ids = np.array(target_data['answer_id'])

        target_indices = []
        for index, answer_id in enumerate(y):
            if answer_id in target_answer_ids or answer_id == Reply.CLASSIFY_FAILED_ANSWER_ID:
                target_indices.append(index)

        x = x[target_indices]
        y = y[target_indices]

        logger.debug("TrainingMessageFromCsv#__extract_target_training_set count: samples=%d, features=%d, labels=%d target=%s" % (
            x.shape[0], x.shape[1], np.size(np.unique(y)), os.path.basename(self._file_path)
        ))
        return x, y
