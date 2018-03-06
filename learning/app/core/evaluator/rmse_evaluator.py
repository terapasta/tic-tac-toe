import numpy as np
from app.core.evaluator.base_evaluator import BaseEvaluator


class RmseEvaluator(BaseEvaluator):
    """
    RMSE: root mean squared error
    """
    def __init__(self):
        pass

    def evaluate(self, expected_data, actual_data):
        y_expected = np.array(expected_data)
        y_actual = np.array(actual_data)

        # データ数が異なる場合は None を返す
        if y_expected.shape != y_actual.shape:
            return None

        N = y_expected.shape[0]
        value = np.sqrt(np.sum((y_expected - y_actual) * (y_expected - y_actual)) / float(N))
        return value
