from injector import inject
import pandas as pd
# from sklearn.grid_search import GridSearchCV
from sklearn.linear_model import LogisticRegression as SkLogisticRegression
from app.core.estimator.base_estimator import BaseEstimator
from app.shared.datasource.datasource import Datasource


class LogisticRegression(BaseEstimator):
    @inject
    def __init__(self, datasource: Datasource, dump_key='sk_logistic_regression'):
        self.persistence = datasource.persistence
        self._dump_key = dump_key
        self.estimator = None

    def fit(self, x, y):
        # Note: This module will be removed in 0.20.", DeprecationWarning) が発生するのでgridsearchは一旦止める
        #
        # params = {'C': [10, 100, 140, 200]}
        # grid = GridSearchCV(SkLogisticRegression(), param_grid=params)
        # grid.fit(x, y)
        # self.estimator = grid.best_estimator_
        self.estimator = SkLogisticRegression()
        self.persistence.dump(self.estimator, self.dump_key)

    def predict(self, question_features):
        self._prepare_instance_if_needed()
        results = self.estimator.predict_proba(question_features)
        return pd.DataFrame({
                'question_answer_id': self.estimator.classes_,
                'probability': results[0],
            })

    @property
    def dump_key(self):
        return self._dump_key

    def _prepare_instance_if_needed(self):
        if self.estimator is None:
            self.estimator = self.persistence.load(self.dump_key)
