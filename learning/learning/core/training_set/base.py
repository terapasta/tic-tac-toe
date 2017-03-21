from abc import ABCMeta, abstractmethod

import numpy as np


class Base(metaclass=ABCMeta):
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
