import math
import numpy as np
from app.core.error.invalid_data_format_error import InvalidDataFormatError
from app.core.evaluator.base_evaluator import BaseEvaluator


class McllEvaluator(BaseEvaluator):
    """
    MCLL: multi-class logarithmic loss
    """
    def __init__(self):
        pass

    def evaluate(self, expected_ids, actual_probs):
        sum = 0
        for y_e, y_a in zip(expected_ids, actual_probs):
            # y_e is an expected class id
            # y_a is an array or dict of probabilities for each class
            sum += math.log(y_a[y_e])

        N = len(expected_ids)
        value = - sum / float(N)
        return value
