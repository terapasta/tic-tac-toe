from app.shared.base_cls import BaseCls


class BasePipe(BaseCls):
    def __init__(self):
        raise NotImplementedError()

    def perform(self, texts):
        raise NotImplementedError()
