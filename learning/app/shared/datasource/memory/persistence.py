import inject
from app.shared.app_status import AppStatus


class Persistence:
    @inject.params(app_status=AppStatus)
    def __init__(self, app_status=None):
        self.bot = app_status.current_bot()
        self.data = {}

    def load(self, key):
        if self.__generate_key(key) in self.data:
            return self.data[self.__generate_key(key)]
        return None

    def dump(self, obj, key):
        self.data[self.__generate_key(key)] = obj

    def __generate_key(self, key):
        return '{}/alg{}_{}'.format(self.bot.dump_dirpath, self.bot.algorithm, key)
