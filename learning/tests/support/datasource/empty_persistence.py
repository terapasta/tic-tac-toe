class EmptyPersistence:
    def __init__(self):
        pass

    def load(self, key):
        return None

    def dump(self, obj, key):
        pass
