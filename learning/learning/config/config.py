import yaml
import sys

class Config:
    _ENV = None

    def __init__(self):
        with open("learning/config/config.yml", 'r') as ymlfile:
            self.config = yaml.load(ymlfile)
        self.__set_env()

    def get(self, key):
        print(self.config[self.env])
        return self.config[self.env][key]

    def __set_env(self):
        args = sys.argv
        command = args[0]
        self._env = Config._ENV

        if command.endswith('noserunner.py') or command.endswith('nosetests'):
            self._env = 'test'
            return

    @property
    def env(self):
        return self._env
