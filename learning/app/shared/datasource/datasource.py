from app.shared.constants import Constants
from app.shared.datasource.database.persistence import Persistence as PersistenceFromDb
from app.shared.datasource.database.question_answers import QuestionAnswers as QuestionAnswersFromDb
from app.shared.datasource.file.persistence import Persistence as PersistenceFromFile
from app.shared.datasource.file.question_answers import QuestionAnswers as QuestionAnswersFromFile
from app.shared.datasource.file.wiki_corpus import WikiCorpus


class Datasource:
    __shared_state = {}

    def __init__(self, persistence=None, question_answers=None):
        self.__dict__ = self.__shared_state

    def init(self, bot=None):
        if bot.datasource_type == Constants.DATASOURCE_TYPE_FILE:
            self._persistence = PersistenceFromFile()
            self._question_answers = QuestionAnswersFromFile()
        else:
            self._persistence = PersistenceFromDb()
            self._question_answers = QuestionAnswersFromDb()

        self._wiki_corpus = WikiCorpus()

    @property
    def persistence(self):
        return self._persistence

    @property
    def question_answers(self):
        return self._question_answers

    @property
    def wiki_corpus(self):
        return self._wiki_corpus
