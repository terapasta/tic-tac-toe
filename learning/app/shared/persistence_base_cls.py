from time import sleep
from app.shared.base_cls import BaseCls

class PersistenceBaseCls(BaseCls):
    def __init__(self):
        pass

    def init_by_bot(self, bot):
        raise NotImplementedError()

    def load(self, key):
        raise NotImplementedError()

    # @property n = #retries [times]
    # @property dt = interval for retry [sec]
    def load_with_retry(self, key, retry=5, dt=0.2):
        for i in range(retry):
            data = self.load(key)
            if data is not None:
                return data

            sleep(dt)
        return None

    def dump(self, obj, key):
        raise NameError()

    def _generate_file_path(self, key):
        raise NameError()
