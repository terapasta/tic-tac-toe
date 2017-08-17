from app.shared.config import Config
from app.shared.constants import Constants


class CurrentBot(object):
    __shared_state = {}

    def __init__(self, config=None):
        self.__dict__ = self.__shared_state
        self.config = config if config is not None else Config()

    def init(self, bot_id, learning_parameter):
        self._bot_id = bot_id
        self._learning_parameter = learning_parameter
        return self

    @property
    def id(self):
        return self._bot_id

    @property
    def learning_parameter(self):
        return self._learning_parameter

    @property
    def dump_dirpath(self):
        return 'dumps/%s/%s' % (self.config.env, self._bot_id)

    @property
    def algorithm(self):
        if self.learning_parameter.get('use_similarity_classification', True):
            return Constants.ALGORITHM_SIMILARITY_CLASSIFICATION

        return self.learning_parameter.get('algorithm', Constants.ALGORITHM_SIMILARITY_CLASSIFICATION)
