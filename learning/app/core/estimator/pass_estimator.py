import pandas as pd
from app.core.estimator.base_estimator import BaseEstimator


class PassEstimator(BaseEstimator):
    def __init__(self):
        pass

    def set_persistence(self, persistence, key=None):
        return self

    def fit(self, x, y):
        pass

    def predict(self, question_features):
        return pd.DataFrame({
                'question_answer_id': [],
                'probability': [],
            })

    @property
    def dump_path(self):
        return ''
