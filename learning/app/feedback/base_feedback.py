from app.shared.base_cls import BaseCls


class BaseFeedback(BaseCls):
    def __init__(self, bot, estimator_for_good, estimator_for_bad, datasource):
        raise NotImplementedError()

    def fit_for_good(self, x, y):
        raise NotImplementedError()

    def fit_for_bad(self, x, y):
        raise NotImplementedError()

    def transform_query_vector(self, question_features):
        raise NotImplementedError()
