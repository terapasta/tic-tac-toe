class EmptyPersistence:
    def __init__(self, app_status=None):
        pass

    def load(self, key):
        return None

    def dump(self, obj, key):
        pass
