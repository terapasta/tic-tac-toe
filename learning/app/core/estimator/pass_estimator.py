import pandas as pd
from app.core.estimator.base_estimator import BaseEstimator


class PassEstimator(BaseEstimator):
    def __init__(self):
        pass

    def init_by_bot(self, bot, key=''):
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
