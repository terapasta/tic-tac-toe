from app.shared.base_cls import BaseCls


class BaseFeedback(BaseCls):
    def __init__(self, bot, estimator_for_good, estimator_for_bad, datasource):
        raise NotImplementedError()

    def fit(self, x, y):
        raise NotImplementedError()

    def predict(self, question_features):
        raise NotImplementedError()

    def before_reply(self, sentences):
        raise NotImplementedError()

    def after_reply(self, question, data_frame):
        raise NotImplementedError()
