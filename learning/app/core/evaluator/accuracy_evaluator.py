import math
import numpy as np
from app.core.error.invalid_data_format_error import InvalidDataFormatError
from app.core.evaluator.base_evaluator import BaseEvaluator


class AccuracyEvaluator(BaseEvaluator):
    """
    Accuracy
    """
    def __init__(self):
        pass

    def evaluate(self, expected_ids, actual_ids):
        sum = 0
        for y_e, y_a in zip(expected_ids, actual_ids):
            # y_e is an expected class id
            # y_a is an actual class id
            if y_e == y_a:
                sum += 1.0

        N = len(expected_ids)
        return sum / float(N)
