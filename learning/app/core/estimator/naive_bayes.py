import inject
import pandas as pd
from sklearn.naive_bayes import MultinomialNB
from app.core.estimator.base_estimator import BaseEstimator
from app.shared.datasource.datasource import Datasource


class NaiveBayes(BaseEstimator):
    @inject.params(
        datasource=Datasource,
    )
    def __init__(self, datasource=None):
        self.persistence = datasource.persistence
        self.estimator = self.persistence.load(self.dump_key)
        if self.estimator is None:
            self.estimator = MultinomialNB()

    def fit(self, x, y):
        self.estimator.fit(x, y)
        self.persistence.dump(self.estimator, self.dump_key)

    def predict(self, question_features):
        results = self.estimator.predict_proba(question_features)
        return pd.DataFrame({
                'question_answer_id': self.estimator.classes_,
                'probability': results[0],
            })

    @property
    def dump_key(self):
        return 'sk_naive_bayes_estimator'
