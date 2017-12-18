from injector import inject
from app.core.tokenizer.mecab_tokenizer import MecabTokenizer
from app.core.vectorizer.tfidf_vectorizer import TfidfVectorizer
from app.shared.base_cls import BaseCls
from app.shared.config import Config
from app.shared.context import Context
from app.shared.constants import Constants
from app.shared.datasource.datasource import Datasource
from app.shared.datasource.file.question_answers import QuestionAnswers
from tests.support.datasource.empty_persistence import EmptyPersistence
from tests.support.datasource.empty_question_answers import EmptyQuestionAnswers
from tests.support.datasource.empty_ratings import EmptyRatings


class LearningParameter:
    def __init__(self, algorithm, feedback_algorithm):
        self.algorithm = algorithm
        self.feedback_algorithm = feedback_algorithm


class TextToVectorHelper(BaseCls):
    @inject
    def __init__(self, tokenizer: MecabTokenizer, vectorizer: TfidfVectorizer):
        self._tokenizer = tokenizer
        self._vectorizer = vectorizer
        self.fitted = False

    def vectorize(self, text):
        sentences = self._tokenizer.tokenize(text)
        if self.fitted is False:
            qas = QuestionAnswers().all()
            self._vectorizer.fit(qas['question'])
            self.fitted = True

        return self._vectorizer.transform(sentences)

    @property
    def tokenizer(self):
        return self._tokenizer

    @property
    def vectorizer(self):
        return self._vectorizer


class Helper:
    @classmethod
    def init(cls):
        Config().init('test')

    @classmethod
    def test_context(cls, bot_id, algorithm=Constants.ALGORITHM_SIMILARITY_CLASSIFICATION, feedback_algorithm=Constants.FEEDBACK_ALGORITHM_NONE, datasource=None):
        if datasource is None:
            datasource = Datasource()
        return Context.new(
            bot_id=bot_id,
            learning_parameter=LearningParameter(algorithm=algorithm, feedback_algorithm=feedback_algorithm),
            grpc_context={},
            datasource=datasource,
        )

    @classmethod
    def empty_datasource(cls):
        return Datasource.new(
            persistence=EmptyPersistence(),
            question_answers=EmptyQuestionAnswers(),
            ratings=EmptyRatings(),
        )
