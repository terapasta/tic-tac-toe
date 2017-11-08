from abc import ABCMeta, abstractmethod


class BaseEstimator(metaclass=ABCMeta):
    @abstractmethod
    def __init__(self, persistence=None):
        pass

    @abstractmethod
    def fit(self, x, y):
        pass

    @abstractmethod
    def predict(self, question_features):
        pass

    @property
    @abstractmethod
    def dump_key(self):
        pass
