import pandas as pd
from learning.core.training_set.base import Base
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
        body_array = TextArray(learning_training_messages['question'])
        x = body_array.to_vec()

        self._body_array = body_array
        self._x = x
        self._y = learning_training_messages['answer_id']
        return self

    @property
    def body_array(self):
        return self._body_array

    def __build_learning_training_messages(self):
        if type(self._file_path) == list:
            datas = []
            for file_path in self._file_path:
                d = pd.read_csv(file_path, encoding=self._encoding)
                datas.append(d)
            data = pd.concat(datas)
        else:
            data = pd.read_csv(self._file_path, encoding=self._encoding)
        logger.debug("TrainingMessageFromCsv#__build_learning_training_messages count of learning data: %s" % data['id'].count())
        return data