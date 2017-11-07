import inject
from app.shared.config import Config
from app.shared.app_status import AppStatus


class LearningParameter:
    def __init__(self, algorithm):
        self.algorithm = algorithm


class Helper:
    @classmethod
    def init(cls, bot_id, algorithm):
        inject.configure_once()
        Config().init('test')
        AppStatus().set_bot(bot_id=1, learning_parameter=LearningParameter(algorithm=algorithm))
