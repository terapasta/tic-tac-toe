from app.shared.config import Config
from app.shared.constants import Constants
from app.shared.base_cls import BaseCls
from app.shared.datasource.database.persistence import Persistence as PersistenceFromDb
from app.shared.datasource.database.question_answers import QuestionAnswers as QuestionAnswersFromDb
from app.shared.datasource.database.ratings import Ratings as RatingsFromDb
from app.shared.datasource.database.learning_parameters import LearningParameters as LearningParametersFromDb
from app.shared.datasource.file.persistence import Persistence as PersistenceFromFile
from app.shared.datasource.file.question_answers import QuestionAnswers as QuestionAnswersFromFile
from app.shared.datasource.file.ratings import Ratings as RatingsFromFile
from app.shared.datasource.memory.persistence import Persistence as PersistenceFromMemory


class Datasource(BaseCls):
    def __init__(self, persistence=None, question_answers=None, ratings=None):
        datasource_type = Config().get('datasource_type')
        if datasource_type == Constants.DATASOURCE_TYPE_FILE:
            self._persistence = PersistenceFromFile.new()
            self._question_answers = QuestionAnswersFromFile.new()
            self._ratings = RatingsFromFile.new()
        else:
            self._persistence = PersistenceFromDb.new()
            self._question_answers = QuestionAnswersFromDb.new()
            self._ratings = RatingsFromDb.new()

        if Config.env == 'test':
            # HACK: new(inject)できない?
            self._persistence = PersistenceFromMemory()

        if persistence is not None:
            self._persistence = persistence
        if question_answers is not None:
            self._question_answers = question_answers
        if ratings is not None:
            self._ratings = ratings

        # TODO: file version
        self._learning_parameters = LearningParametersFromDb()

    @property
    def persistence(self):
        return self._persistence

    @property
    def question_answers(self):
        return self._question_answers

    @property
    def ratings(self):
        return self._ratings

    @property
    def learning_parameters(self):
        return self._learning_parameters
