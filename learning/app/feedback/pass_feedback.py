from app.feedback.base_feedback import BaseFeedback


class PassFeedback(BaseFeedback):
    def __init__(self):
        pass

    def fit_for_good(self, x, y):
        pass

    def fit_for_bad(self, x, y):
        pass

    def transform_query_vector(self, query_vector):
        return query_vector
