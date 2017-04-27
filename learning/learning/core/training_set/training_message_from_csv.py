import numpy as np
import pandas as pd
import os

from learning.core.predict.reply import Reply
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
        questions = np.array(learning_training_messages['question'])
        answer_ids = np.array(learning_training_messages['answer_id'])

        # 空のテキストにラベル0を対応付けるために強制的にトレーニングセットを追加
        questions = np.append(questions, [''] * self.COUNT_OF_APPEND_BLANK)
        answer_ids = np.append(answer_ids, [Reply.CLASSIFY_FAILED_ANSWER_ID] * self.COUNT_OF_APPEND_BLANK)

        if self._learning_parameter.vectorize_using_all_bots == True:
            '''
                該当Botのデータを抽出時、ラベル0が含まれるようにするため、
                ラベル0のレコードと、引数のファイル名を関連づけておく
            '''
            dataset_names = np.array(learning_training_messages['dataset_name'])
            target_data_set_name = os.path.basename(self._file_path)
            dataset_names = np.append(dataset_names, [target_data_set_name] * self.COUNT_OF_APPEND_BLANK)

        body_array = TextArray(questions)
        x = body_array.to_vec()
        y = answer_ids

        if self._learning_parameter.vectorize_using_all_bots == True:
            '''
                該当Botに関連づけられたデータのインデックスを取得し、
                該当Botに対応するTFIDF値／ラベルだけを抽出
            '''
            logger.debug("TrainingMessageFromCsv#build count(all): samples=%d, features=%d, labels=%d" % (
                x.shape[0], x.shape[1], np.size(np.unique(y))
            ))

            target_indices = np.where(dataset_names==target_data_set_name)
            x = x[target_indices]
            y = y[target_indices]
            logger.debug("TrainingMessageFromCsv#build count: samples=%d, features=%d, labels=%d target=%s" % (
                x.shape[0], x.shape[1], np.size(np.unique(y)), target_data_set_name
            ))

        self._body_array = body_array
        self._x = x
        self._y = y
        return self

    @property
    def body_array(self):
        return self._body_array

    def __build_learning_training_messages(self):
        if self._learning_parameter.vectorize_using_all_bots == False:
            data = pd.read_csv(self._file_path, encoding=self._encoding)
            logger.debug("TrainingMessageFromCsv#__build_learning_training_messages count of learning data: %s" % data['id'].count())
            return data

        csv_file_paths = []
        upper_path = os.path.dirname(self._file_path)
        for f in os.listdir(upper_path):
            ''' 
                self._file_pathと同じディレクトリ配下にある
                全てのCSVファイルパスを取得
            '''
            if os.path.splitext(f)[1] == '.csv':
                csv_file_paths.append(os.path.join(upper_path, f))

        dataframes = []
        for path in csv_file_paths:
            '''
                外部ボキャブラリとして使用できないCSVがあった場合はスキップ
                (1) CSVが読めない場合
                (2) answer_body列がない場合
            '''
            try:
                learning_training_messages = pd.read_csv(path, encoding=self._encoding)
            except:
                logger.debug("TrainingMessageFromCsv#__build_learning_training_messages Invalid dataset: skipped %s" % path)
                continue

            if not 'answer_body' in learning_training_messages.columns:
                logger.debug("TrainingMessageFromCsv#__build_learning_training_messages Dataframe has not 'answer_body': skipped %s" % path)
                continue

            '''
                該当Botのデータだけを抽出できるようにするため、
                データセット名を列として追加
            '''
            target_data_set_name = os.path.basename(path)
            learning_training_messages['dataset_name'] = target_data_set_name
            dataframes.append(learning_training_messages)
            logger.debug("TrainingMessageFromCsv#__build_learning_training_messages Dataset for vectorization: %s (count=%d)" % (target_data_set_name, learning_training_messages['id'].count()))

        data = pd.concat(dataframes)
        logger.debug("TrainingMessageFromCsv#__build_learning_training_messages count of learning data: %s" % data['id'].count())

        return data
