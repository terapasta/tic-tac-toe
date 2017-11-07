import inject
from app.shared.config import Config
from app.shared.app_status import AppStatus
from app.shared.datasource.datasource import Datasource

from app.shared.datasource.file.question_answers import QuestionAnswers as QuestionAnswersFromFile
from app.shared.datasource.file.ratings import Ratings as RatingsFromFile
from app.shared.datasource.memory.persistence import Persistence as PersistenceFromMemory


class LearningParameter:
    def __init__(self, algorithm):
        self.algorithm = algorithm


class Helper:
    @classmethod
    def init(cls, bot_id, algorithm):
        inject.configure_once()
        Config().init('test')
        AppStatus().set_bot(bot_id=1, learning_parameter=LearningParameter(algorithm=algorithm))
        Datasource(
            persistence=PersistenceFromMemory,
            question_answers=QuestionAnswersFromFile,
            ratings=RatingsFromFile,
        )
