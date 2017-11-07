import inject
from app.shared.app_status import AppStatus


class Persistence:
    @inject.params(app_status=AppStatus)
    def __init__(self, app_status=None):
        self.bot = app_status.current_bot()
        self.data = {}

    def load(self, key):
        return self.data[self.__generate_key(key)]

    def dump(self, obj, key):
        self.data[self.__generate_key(key)] = obj

    def __generate_key(self, key):
        return '{}/alg{}_{}'.format(self.bot.dump_dirpath, self.bot.algorithm, key)
