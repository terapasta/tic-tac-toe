import pandas as pd
from injector import inject
from sklearn.naive_bayes import MultinomialNB
from app.shared.logger import logger
from app.core.estimator.base_estimator import BaseEstimator
from app.shared.datasource.datasource import Datasource


class NaiveBayes(BaseEstimator):
    @inject
    def __init__(self, datasource: Datasource, dump_key='sk_naive_bayes_estimator'):
        self.persistence = datasource.persistence
        self._dump_key = dump_key
        self.estimator = None

    def fit(self, x, y):
        self._prepare_instance_if_needed()
        self.estimator.fit(x, y)
        self.persistence.dump(self.estimator, self.dump_key)

    def predict(self, question_features):
        self._prepare_instance_if_needed()
        logger.debug(self.estimator.feature_count_.shape)
        logger.debug(question_features.shape)
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
        if self.estimator is None:
            self.estimator = MultinomialNB()
