from app.shared.config import Config


class CurrentBot(object):
    __shared_state = {}

    def __init__(self, config=None):
        self.__dict__ = self.__shared_state
        self.config = config if config is not None else Config()

    def init(self, bot_id):
        self._bot_id = bot_id

    @property
    def id(self):
        return self._bot_id

    @property
    def dump_dirpath(self):
        return 'dumps/%s/%s' % (self.config.env, self._bot_id)
