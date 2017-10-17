import inject
import os
from pathlib import Path
from sklearn.externals import joblib
from app.shared.current_bot import CurrentBot


class Persistence:
    @inject.params(bot=CurrentBot)
    def __init__(self, bot=None):
        self.bot = bot

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
