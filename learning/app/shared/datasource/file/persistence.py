import os
from time import sleep
from injector import inject
from pathlib import Path
from sklearn.externals import joblib
from app.shared.config import Config
from app.shared.base_cls import BaseCls

class Persistence(BaseCls):
    @inject
    def __init__(self):
        self.id = 0
        self.algorithm = 'none'

    def init_by_bot(self, bot):
        self.id = bot.id
        self.algorithm = bot.algorithm
        return self

    def load(self, key):
        path = self._generate_file_path(key)
        if Path(path).is_file():
            return joblib.load(path)

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
        path = self._generate_file_path(key)
        dirpath = os.path.dirname(path)
        if not Path(dirpath).is_dir():
            os.mkdir(dirpath)

        joblib.dump(obj, path)

    def _generate_file_path(self, key):
        return 'dumps/{}/{}/alg{}_{}'.format(Config().env, self.id, self.algorithm, key)
