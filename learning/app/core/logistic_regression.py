from injector import inject
from app.shared.logger import logger
from app.shared.datasource.datasource import Datasource
from app.core.estimator.logistic_regression import LogisticRegression as LogisticRegressionEstimator
from app.core.base_core import BaseCore


class LogisticRegression(BaseCore):
    @inject
    def __init__(self, bot, datasource: Datasource, estimator: LogisticRegressionEstimator):
        self.persistence = datasource.persistence
        self.estimator = estimator

    def fit(self, x, y):
        self.estimator.fit(x, y)

    def predict(self, question_features):
        return self.estimator.predict(question_features)

    def before_reply(self, sentences):
        logger.info('PASS')
        return sentences

    def after_reply(self, question, data_frame):
        logger.info('PASS')
        return data_frame
