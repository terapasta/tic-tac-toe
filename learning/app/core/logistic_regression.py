import inject
import pandas as pd
from sklearn.grid_search import GridSearchCV
from sklearn.linear_model import LogisticRegression as SkLogisticRegression
from app.shared.logger import logger
from app.shared.app_status import AppStatus
from app.shared.datasource.file.persistence import Persistence


class LogisticRegression:
    @inject.params(
        persistence=Persistence,
        app_status=AppStatus,
    )
    def __init__(self, bot=None, persistence=None, app_status=None):
        self.bot = app_status.current_bot()
        self.persistence = persistence
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

    def before_reply(self, sentences):
        logger.info('PASS')
        return sentences

    def after_reply(self, question, data_frame):
        logger.info('PASS')
        return data_frame

    @property
    def dump_key(self):
        return 'sk_logistic_regression_estimator'
