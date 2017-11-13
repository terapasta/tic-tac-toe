import inject
import pandas as pd
from sklearn.grid_search import GridSearchCV
from sklearn.linear_model import LogisticRegression as SkLogisticRegression
from app.core.estimator.base_estimator import BaseEstimator
from app.shared.datasource.datasource import Datasource


class LogisticRegression(BaseEstimator):
    @inject.params(
        datasource=Datasource,
    )
    def __init__(self, datasource=None):
        self.persistence = datasource.persistence
        self.estimator = self.persistence.load(self.dump_key)

    def fit(self, x, y):
        params = {'C': [10, 100, 140, 200]}
        grid = GridSearchCV(SkLogisticRegression(), param_grid=params)
        grid.fit(x, y)
        self.estimator = grid.best_estimator_
        self.persistence.dump(self.estimator, self.dump_key)

    def predict(self, question_features):
        results = self.estimator.predict_proba(question_features)
        return pd.DataFrame({
                'question_answer_id': self.estimator.classes_,
                'probability': results[0],
            })

    @property
    def dump_key(self):
        return 'sk_logistic_regression_estimator'
