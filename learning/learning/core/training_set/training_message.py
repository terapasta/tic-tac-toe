# -*- coding: utf-8 -
import MeCab
import numpy as np
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.externals import joblib
from ..nlang import Nlang

class TrainingMessage:
    NUMBER_OF_CONTEXT = 0

    def __init__(self, db):
        self.training_messages = db['training_messages'].find(order_by='training_id, id')

    # TODO numpyのarrayを使う
    #
    # DBのテーブルを検索した結果をfeatureとして使える形式に整形する
    #
    # +----+-------------+-----------+---------+--------------------------------------------------+
    # | id | training_id | answer_id | speaker | body                                             |
    # +----+-------------+-----------+---------+--------------------------------------------------+
    # |  1 |           1 |      NULL | guest   | おーい                                           |
    # |  2 |           1 |         2 | bot     | はーい。なんですか？                             |
    # |  3 |           1 |      NULL | guest   | 最近調子はどう？                                 |
    # |  4 |           1 |         3 | bot     | ぼちぼちでんな                                   |
    # |  5 |           1 |      NULL | guest   | 儲かってるってこと？                             |
    # |  6 |           1 |         4 | bot     | まあそれもぼちぼちってこっちゃ。                 |
    # |  7 |           1 |      NULL | guest   | じゃあきっといいもの食べてるね？                 |
    # |  8 |           1 |         5 | bot     | まあね。カニとか食べるよ                         |
    # +----+-------------+-----------+---------+--------------------------------------------------+
    #
    # => 下記のようなデータに整形する
    #
    # [[0, 0, 0, 0, 'おーい', 2],
    # [0, 0, 0, 2, '最近調子はどう？', 3],
    # [0, 0, 2, 3, '儲かってるってこと？', 4],
    # [0, 2, 3, 4, 'じゃあきっといいもの食べてるよね？', 5]]
    def build(self):
        trainings = self.__partition_each_training(self.training_messages)
        training_sets = []

        for tmp_training_set in trainings:
            self.__pad_none_data(tmp_training_set)
            answer_id_indexs = self.__lookup_anser_indexs(tmp_training_set)

            for answer_id_index in answer_id_indexs:
                training_set = []

                for training_message in tmp_training_set[answer_id_index:]:
                    if len(training_set) < self.NUMBER_OF_CONTEXT:
                        if training_message['answer_id'] is not None:
                            training_set.append(training_message['answer_id'])
                    elif len(training_set) == self.NUMBER_OF_CONTEXT:
                        if training_message['answer_id'] is None:
                            training_set.append(training_message['body'])
                    elif len(training_set) == self.NUMBER_OF_CONTEXT + 1:
                        if training_message['answer_id'] is not None:
                            training_set.append(training_message['answer_id'])

                if len(training_set) >= self.NUMBER_OF_CONTEXT + 2:
                    training_sets.append(training_set)

        bodies = self.__extract_bodies(training_sets)
        bodies = self.__split_bodies(bodies)
        bodies_vec = Nlang.texts2vec(bodies, 'learning/vocabulary/vocabulary.pkl')  # TODO 定数化したい
        feature = self.__combine(training_sets, bodies_vec)
        return feature

    # trainingごとのtraining_messageに分ける
    def __partition_each_training(self, training_messages):
        trainings = []
        tmp_training_messages = []
        pre_training_id = None

        for training_message in self.training_messages:
            if pre_training_id == training_message['training_id'] or pre_training_id is None:
                tmp_training_messages.append(training_message)
            else:
                trainings.append(tmp_training_messages)
                tmp_training_messages = []
                pre_training_id = training_message['training_id']

        if tmp_training_messages:
            trainings.append(tmp_training_messages)

        return trainings

    def __pad_none_data(self, training_messages):
        if self.NUMBER_OF_CONTEXT >= 2:
            for i in range(0, self.NUMBER_OF_CONTEXT - 1):
                training_messages.insert(0, dict(answer_id=0, body=''))

    def __lookup_anser_indexs(self, training_messages):
        answer_id_indexs = []
        for index, training_message in enumerate(training_messages):
            if training_message['answer_id'] is not None:
                answer_id_indexs.append(index)
        return answer_id_indexs

    def __extract_bodies(self, training_sets):
        bodies = []
        for training_set in training_sets:
            bodies.append(training_set[-2])

        return bodies

    def __split_bodies(self, bodies):
        splited_bodies = []
        for body in bodies:
            splited_bodies.append(Nlang.split(body))
        return splited_bodies

    def __combine(self, training_sets, bodies_vec):
        tmp_training_sets = np.array(training_sets)
        #labels = tmp_training_sets
        #tmp_bodies_vec = np.array(bodies_vec)
        #tmp_training_sets = np.delete(tmp_training_sets, -2, 1)
        #feature = np.c_[tmp_training_sets[:,:-2], tmp_bodies_vec, tmp_training_sets[:,-1:]]
        feature = np.c_[tmp_training_sets[:,:-2], bodies_vec.toarray(), tmp_training_sets[:,-1:]]
        return feature
