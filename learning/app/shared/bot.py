from app.shared.config import Config
from app.shared.base_cls import BaseCls


class Bot(BaseCls):
    def __init__(self, bot_id, learning_parameter, config=None):
        self._bot_id = bot_id
        self._learning_parameter = learning_parameter
        self.config = config if config is not None else Config()

    @property
    def id(self):
        return self._bot_id

    @property
    def dump_key_prefix(self):
        return 'alg{}_'.format(self.algorithm)

    @property
    def algorithm(self):
        return self._learning_parameter.algorithm

    @property
    def feedback_algorithm(self):
        return self._learning_parameter.feedback_algorithm
