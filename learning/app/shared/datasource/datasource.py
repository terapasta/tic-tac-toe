from app.shared.config import Config
from app.shared.constants import Constants
from app.shared.datasource.database.persistence import Persistence as PersistenceFromDb
from app.shared.datasource.database.question_answers import QuestionAnswers as QuestionAnswersFromDb
from app.shared.datasource.database.ratings import Ratings as RatingsFromDb
from app.shared.datasource.file.persistence import Persistence as PersistenceFromFile
from app.shared.datasource.file.question_answers import QuestionAnswers as QuestionAnswersFromFile
from app.shared.datasource.file.ratings import Ratings as RatingsFromFile


class Datasource:
    def __init__(self, persistence=None, question_answers=None, ratings=None):
        if Config().get('datasource_type') == Constants.DATASOURCE_TYPE_FILE:
            self._persistence = PersistenceFromFile
            self._question_answers = QuestionAnswersFromFile
            self._ratings = RatingsFromFile
        else:
            self._persistence = PersistenceFromDb
            self._question_answers = QuestionAnswersFromDb
            self._ratings = RatingsFromDb

        if persistence is not None:
            self._persistence = persistence
        if question_answers is not None:
            self._question_answers = question_answers
        if ratings is not None:
            self._ratings = ratings

    @property
    def persistence(self):
        return self._persistence()

    @property
    def question_answers(self):
        return self._question_answers()

    @property
    def ratings(self):
        return self._ratings()
