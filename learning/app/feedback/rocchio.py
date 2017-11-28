from app.feedback.base_feedback import BaseFeedback
from app.core.estimator.rocchio import Rocchio as RocchioEstimator
from app.shared.datasource.datasource import Datasource
from app.shared.custom_errors import NotTrainedError


class Rocchio(BaseFeedback):
    # Note: ハイパーパラメータ
    QUERY_WAIT = 1
    POSITIVE_WAIT = 0.5
    NEGATIVE_WAIT = 0.3

    def __init__(self, estimator_for_good: RocchioEstimator, estimator_for_bad: RocchioEstimator, datasource: Datasource):
        self.estimator_for_good = estimator_for_good
        self.estimator_for_bad = estimator_for_bad
        self.persistence = datasource.persistence
        self.data = {'good': None, 'bad': None}

    def fit_for_good(self, x, y):
        self.data['good'] = dict(zip(y, x))
        self.estimator_for_good.fit(x, y)
        self._dump()

    def fit_for_bad(self, x, y):
        self.data['bad'] = dict(zip(y, x))
        self.estimator_for_bad.fit(x, y)
        self._dump()

    def transform_query_vector(self, query_vector):
        try:
            self._prepare_data()
            posi_result = self.estimator_for_good.predict(query_vector)
            positive_vectors = self.data['good'][posi_result['question_answer_id'][0]]
            nega_result = self.estimator_for_bad.predict(query_vector)
            negative_vectors = self.data['bad'][nega_result['question_answer_id'][0]]

            new_vector = (self.QUERY_WAIT * query_vector) + (self.POSITIVE_WAIT * positive_vectors) - (self.NEGATIVE_WAIT * negative_vectors)
            return new_vector
        except NotTrainedError:
            return query_vector

    def _dump(self):
        if self._fitted():
            self.persistence.dump(self.data, self.dump_key)

    @property
    def dump_key(self):
        return 'rocchio_feedback'

    def _fitted(self):
        good = self.data['good'] is not None
        bad = self.data['bad'] is not None
        return good and bad

    def _prepare_data(self):
        if not self._fitted():
            self.data = self.persistence.load(self.dump_key)
        if self.data is None or not self._fitted():
            raise NotTrainedError()
