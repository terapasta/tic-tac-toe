from app.shared.base_cls import BaseCls


class Persistence(BaseCls):
    __shared_state = {}
    data = {}

    def __init__(self):
        self.__dict__ = self.__shared_state
        self.id = 0
        self.algorithm = 'none'

    def init_by_bot(self, bot):
        self.id = bot.id
        self.algorithm = bot.algorithm
        return self

    def load(self, key):
        if self._generate_key(key) in self.data:
            return self.data[self._generate_key(key)]
        return None

    def dump(self, obj, key):
        self.data[self._generate_key(key)] = obj

    def _generate_key(self, key):
        return 'bot{}_alg{}_{}'.format(self.id, self.algorithm, key)
