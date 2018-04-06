from app.shared.base_cls import BaseCls


class BaseEvaluator(BaseCls):
    def __init__(self):
        raise NotImplementedError()

    def evaluate(self, expected_data, actual_data):
        raise NotImplementedError()
