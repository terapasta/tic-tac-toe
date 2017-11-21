from app.shared.base_cls import BaseCls


class EmptyPersistence(BaseCls):
    def __init__(self):
        pass

    def load(self, key):
        return None

    def dump(self, obj, key):
        pass
