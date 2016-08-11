import yaml

class Config:

    def __init__(self):
        with open("learning/config/config.yml", 'r') as ymlfile:
            self.config = yaml.load(ymlfile)

    def get(self, key):
        return self.config[key]
