from abc import ABCMeta, abstractmethod

import numpy as np


class Base(metaclass=ABCMeta):
    COUNT_OF_APPEND_BLANK = 3

    @abstractmethod
    def build(self):
        pass

    @property
    def x(self):
        return self._x

    @x.getter
    def x(self):
        return self._x

    @property
    def y(self):
        return self._y

    @y.getter
    def y(self):
        return self._y

    def count_sample_by_y(self):
        '''
            ラベルごとのサンプル数を調査
        '''
        y = np.asarray(self.y)
        n_samples = y.shape[0]

        unique_labels, y_inversed = np.unique(y, return_inverse=True)
        label_counts = self.__bincount(y_inversed)

        sample_count = []
        for i, unique_label in enumerate(unique_labels):
            sample_count.append([unique_label, label_counts[i]])

        return sample_count

    def __bincount(self, x, weights=None, minlength=None):
        if len(x) > 0:
            return np.bincount(x, weights, minlength)
        else:
            if minlength is None:
                minlength = 0
            minlength = np.asscalar(np.asarray(minlength, dtype=np.intp))
            return np.zeros(minlength, dtype=np.intp)

    def indices_of_train_and_excluded_data(self, excluded_labels):
        '''
            学習セットから指定のラベルを分離する。
            parameter
              excluded_labels 学習セットから分離したいラベル (list)
            return
              学習セットにおけるサンプルのインデックス (numpy.ndarray)
                indices_train: 分離ラベル以外のインデックス
                indices_exluded: 分離ラベルのインデックス
        '''
        indices_train_list = []
        indices_exluded_list = []

        for index, label in enumerate(self.y):
            if label not in excluded_labels:
                indices_train_list.append(index)
            else:
                indices_exluded_list.append(index)

        indices_train = np.array(indices_train_list, dtype=np.int64)
        indices_exluded = np.array(indices_exluded_list, dtype=np.int64)

        return indices_train, indices_exluded
