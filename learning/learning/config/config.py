import yaml
import sys

class Config:

    def __init__(self):
        with open("learning/config/config.yml", 'r') as ymlfile:
            self.config = yaml.load(ymlfile)
        self.__set_env()

    def get(self, key):
        print(self.config[self.env])
        return self.config[self.env][key]

    def __set_env(self):
        args = sys.argv
        self._env = 'development'
        if len(args) > 1:
            self._env = args[1]

    @property
    def env(self):
        return self._env
