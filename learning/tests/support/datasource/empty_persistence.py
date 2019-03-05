from app.shared.base_cls import BaseCls


class EmptyPersistence(BaseCls):
    def __init__(self):
        pass

    def init_by_bot(self, bot):
        return self

    def load(self, key):
        return None

    def load_with_retry(self, key, retry=5, dt=.1):
        return None

    def dump(self, obj, key):
        pass
