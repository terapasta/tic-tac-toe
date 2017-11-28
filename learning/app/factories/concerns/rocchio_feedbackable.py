from app.core.estimator.rocchio import Rocchio as RocchioEstimator
from app.feedback.rocchio import Rocchio


class RocchioFeedbackable:
    _feedback = None

    @property
    def feedback(self):
        if self._feedback is not None:
            return self._feedback

        datasource = self.get_datasource()
        self._feedback = Rocchio.new(
            estimator_for_good=RocchioEstimator.new(datasource=datasource, dump_key='sk_rocchio_good'),
            estimator_for_bad=RocchioEstimator.new(datasource=datasource, dump_key='sk_rocchio_bad'),
            datasource=datasource,
        )
        return self._feedback
