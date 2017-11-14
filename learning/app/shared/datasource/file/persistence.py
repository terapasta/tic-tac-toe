import os
import inject
from pathlib import Path
from sklearn.externals import joblib
from app.shared.config import Config


class Persistence:
    @inject.params(config=Config)
    def __init__(self, config=None):
        self.config = config

    def load(self, bot_id, key):
        path = self._generate_file_path(bot_id, key)
        if Path(path).is_file():
            return joblib.load(path)

        return None

    def dump(self, obj, bot_id, key):
        path = self._generate_file_path(bot_id, key)
        dirpath = os.path.dirname(path)
        if not Path(dirpath).is_dir():
            os.mkdir(dirpath)

        joblib.dump(obj, path)

    def _generate_file_path(self, bot_id, key):
        return 'dumps/{}/{}/{}'.format(self.config.env, bot_id, key)
