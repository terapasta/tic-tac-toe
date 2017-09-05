from app.shared.constants import Constants
from app.shared.datasource.database.loader import Loader as LoaderFromDb
from app.shared.datasource.database.question_answers import QuestionAnswers as QuestionAnswersFromDb
from app.shared.datasource.file.loader import Loader as LoaderFromFile
from app.shared.datasource.file.question_answers import QuestionAnswers as QuestionAnswersFromFile


class Datasource:
    __shared_state = {}

    def __init__(self, loader=None, question_answers=None):
        self.__dict__ = self.__shared_state

    def init(self, bot=None):
        if bot.datasource_type == Constants.DATASOURCE_TYPE_FILE:
            self._loader = LoaderFromFile()
            self._question_answers = QuestionAnswersFromFile()
        else:
            self._loader = LoaderFromDb()
            self._question_answers = QuestionAnswersFromDb()

    @property
    def loader(self):
        return self._loader

    @property
    def question_answers(self):
        return self._question_answers
