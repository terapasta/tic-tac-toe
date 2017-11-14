import os
import inject
from pathlib import Path
from sklearn.externals import joblib
from app.shared.config import Config


class Persistence:
    @inject.params(config=Config)
    def __init__(self, config=None):
        self.config = config
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

    def dump(self, obj, key):
        path = self._generate_file_path(key)
        dirpath = os.path.dirname(path)
        if not Path(dirpath).is_dir():
            os.mkdir(dirpath)

        joblib.dump(obj, path)

    def _generate_file_path(self, key):
        return 'dumps/{}/{}/alg{}_{}'.format(self.config.env, self.id, self.algorithm, key)
