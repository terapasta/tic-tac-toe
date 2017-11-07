from app.shared.app_status import AppStatus


class Persistence:
    __shared_state = {}
    data = {}

    def __init__(self):
        self.__dict__ = self.__shared_state

    def load(self, key):
        if self.__generate_key(key) in self.data:
            return self.data[self.__generate_key(key)]
        return None

    def dump(self, obj, key):
        self.data[self.__generate_key(key)] = obj

    def __generate_key(self, key):
        bot = AppStatus().current_bot()
        return '{}/alg{}_{}'.format(bot.dump_dirpath, bot.algorithm, key)
