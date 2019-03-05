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

    # @property n = #retries [times]
    # @property dt = interval for retry [sec]
    def load_with_retry(self, key, retry=5, dt=0.2):
        for i in range(retry):
            data = self.load(key)
            if data is not None:
                return data

            time.sleep(dt)
        return None

    def dump(self, obj, key):
        self.data[self._generate_key(key)] = obj

    def _generate_key(self, key):
        return 'bot{}_alg{}_{}'.format(self.id, self.algorithm, key)
