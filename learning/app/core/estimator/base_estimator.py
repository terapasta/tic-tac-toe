from abc import ABCMeta, abstractmethod


class BaseEstimator(metaclass=ABCMeta):
    """
    Base of Estimator class
    """

    @abstractmethod
    def fit(self, x, y):
        """
        fitting method
        """
        pass
