import yaml
import sys


class Config(object):
    __shared_state = {}

    def __init__(self):
        self.__dict__ = self.__shared_state
        command = sys.argv[0]
        if command.endswith('noserunner.py') or command.endswith('nosetests'):
            self._env = 'test'

    def init(self, env):
        self._env = env
        with open("config/config.yml", 'r') as ymlfile:
            self.data = yaml.load(ymlfile)

    def get(self, key):
        return self.data[self.env][key]

    @property
    def env(self):
        return self._env
