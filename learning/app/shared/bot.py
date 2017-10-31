from app.shared.config import Config


class Bot(object):
    def __init__(self, bot_id, learning_parameter, config=None):
        self._bot_id = bot_id
        self._learning_parameter = learning_parameter
        self._dump_key_prefix = ''
        self.config = config if config is not None else Config()

    @property
    def id(self):
        return self._bot_id

    @property
    def dump_key_prefix(self):
        return self._dump_key_prefix

    @property
    def dump_dirpath(self):
        return 'dumps/%s/%s' % (self.config.env, self._bot_id)

    @property
    def algorithm(self):
        return self._learning_parameter.algorithm
