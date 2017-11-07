import inject
from app.shared.config import Config
from app.shared.app_status import AppStatus
from app.shared.datasource.datasource import Datasource
from app.shared.constants import Constants


class LearningParameter:
    def __init__(self, algorithm):
        self.algorithm = algorithm


class Helper:
    @classmethod
    def init(cls, bot_id, algorithm, datasource_type=Constants.DATASOURCE_TYPE_FILE):
        inject.configure_once()
        Config().init('test')
        Datasource().init(datasource_type)
        AppStatus().set_bot(bot_id=1, learning_parameter=LearningParameter(algorithm=algorithm))
