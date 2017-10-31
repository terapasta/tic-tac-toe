import inject
import os
from pathlib import Path
from sklearn.externals import joblib
from app.shared.app_status import AppStatus


class Persistence:
    @inject.params(app_status=AppStatus)
    def __init__(self, app_status=None):
        self.bot = app_status.current_bot()

    def load(self, key):
        path = self.__generate_file_path(key)
        if Path(path).is_file():
            return joblib.load(path)

        return None

    def dump(self, obj, key):
        path = self.__generate_file_path(key)
        dirpath = os.path.dirname(path)
        if not Path(dirpath).is_dir():
            os.mkdir(dirpath)

        joblib.dump(obj, path)

    def __generate_file_path(self, key):
        return '{}/alg{}_{}'.format(self.bot.dump_dirpath, self.bot.algorithm, key)
