from injector import inject
import pandas as pd
from sklearn.exceptions import NotFittedError
from app.core.estimator.base_estimator import BaseEstimator
from app.shared.datasource.datasource import Datasource
from app.shared.custom_errors import NotTrainedError
from sklearn.neighbors.nearest_centroid import NearestCentroid


class Rocchio(BaseEstimator):
    @inject
    def __init__(self, datasource: Datasource, dump_key='sk_rocchio'):
        self.persistence = datasource.persistence
        self._dump_key = dump_key
        self.estimator = None

    def fit(self, x, y):
        # Note: yが少ない場合はエラーになる
        try:
            if len(y) >= 3:
                self._prepare_instance_if_needed()
                self.estimator.fit(x, y)
                self.persistence.dump(self.estimator, self.dump_key)
        except:
            # TODO: エラーの原因を解消する
            pass

    def predict(self, vectors):
        self._prepare_instance_if_needed()
        try:
            result = self.estimator.predict(vectors)
            nearlest_qa_id = result[0]
            return pd.DataFrame({
                'question_answer_id': [nearlest_qa_id],
                'probability': [1],
            })
        except NotFittedError as e:
            raise NotTrainedError(e)

    @property
    def dump_key(self):
        return self._dump_key

    def _prepare_instance_if_needed(self):
        if self.estimator is None:
            self.estimator = self.persistence.load(self.dump_key)
        if self.estimator is None:
            self.estimator = NearestCentroid()
