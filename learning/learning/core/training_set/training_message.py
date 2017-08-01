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
            text_array = self.__build_text_array_from_all_bots()
        else:
            text_array = None

        body_vec = text_array.to_vec(questions)

        # if self.learning_parameter.include_tag_vector:
        #     body_vec = body_vec.toarray()
        #     tag_vec = self.__extract_binarized_tag_vector(learning_training_messages)
        #     body_vec = np.c_[tag_vec, body_vec]

        self._body_array = text_array
        self._x = body_vec
        self._y = question_answer_ids
        return self

    def __build_text_array_from_all_bots(self):
        '''
            利用可能な全Botの学習セットを使用するように指定された場合、
            全Botの学習セットを使用してVectorizerを生成
        '''
        all_learning_training_messages = self._datasource.all_learning_training_messages()
        all_questions = np.array(all_learning_training_messages['question'])
        text_array = TextArray()
        _ = text_array.to_vec(all_questions)

        return text_array

    @property
    def body_array(self):
        return self._body_array

    def __extract_binarized_tag_vector(self, learning_training_messages):
        tag_ids = learning_training_messages['tag_ids']
        tag_ids[tag_ids.isnull()] = ','
        tag_ids[tag_ids == ''] = ','
        tag_ids = tag_ids.str.split(':')
        logger.debug("tag_ids: %s" % list(tag_ids))

        try:
            logger.debug("self.binarizer.classes_: %s" % self.binarizer.classes_)
            tag_vector = self.binarizer.transform(tag_ids)
        except KeyError as e:
            logger.error('タグ学習時に存在していなかったタグが含まれている可能性があります。python learn_tag.pyを実行してください。')
            raise e

        logger.debug("tag_vector: %s" % tag_vector)
        return tag_vector