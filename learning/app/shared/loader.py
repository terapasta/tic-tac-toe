import os
from pathlib import Path
from sklearn.externals import joblib
from app.shared.config import Config


class Loader:
    def __init__(self, config=None):
        self.config = config if config is not None else Config()

    def load(self, path):
        if Path(path).is_file():
            return joblib.load(path)

        return None

    def dump(self, obj, path):
        dirpath = os.path.dirname(path)
        if not Path(dirpath).is_dir():
            os.mkdir(dirpath)

        joblib.dump(obj, path)
