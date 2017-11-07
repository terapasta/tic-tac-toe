from app.shared.datasource.file.question_answers import QuestionAnswers as QuestionAnswersFromFile
from app.shared.datasource.file.ratings import Ratings as RatingsFromFile
from app.shared.datasource.memory.persistence import Persistence as PersistenceFromMemory


class TestDatasource:

    def __init__(self):
        self._persistence = PersistenceFromMemory
        self._question_answers = QuestionAnswersFromFile
        self._ratings = RatingsFromFile

    @property
    def persistence(self):
        return self._persistence()

    @property
    def question_answers(self):
        return self._question_answers()

    @property
    def ratings(self):
        return self._ratings()
