import threading
from app.shared.logger import logger
from app.shared.bot import Bot


# Note: スレッドID毎に現在処理中情報を保持するクラス
class AppStatus(object):
    __shared_state = {}
    bots = {}

    def __init__(self):
        self.__dict__ = self.__shared_state

    def set_bot(self, bot_id, learning_parameter):
        logger.debug('thread count: %s' % str(threading.active_count()))
        self.bots[threading.get_ident()] = Bot(bot_id=bot_id, learning_parameter=learning_parameter)
        logger.debug(self.bots)
        return self

    def current_bot(self):
        return self.bots[threading.get_ident()]

    def thread_clear(self):
        del self.bots[threading.get_ident()]
        logger.info('thread cleared')
        logger.debug(self.bots)
