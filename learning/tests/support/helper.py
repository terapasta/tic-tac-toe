import inject
from app.core.tokenizer.mecab_tokenizer import MecabTokenizer
from app.core.vectorizer.tfidf_vectorizer import TfidfVectorizer

from app.shared.config import Config
from app.shared.app_status import AppStatus
from app.shared.datasource.datasource import Datasource

from app.shared.datasource.file.question_answers import QuestionAnswers as QuestionAnswersFromFile
from app.shared.datasource.file.ratings import Ratings as RatingsFromFile
from app.shared.datasource.memory.persistence import Persistence as PersistenceFromMemory


class LearningParameter:
    def __init__(self, algorithm):
        self.algorithm = algorithm


class VectorizedValue:
    def __init__(self, texts, sentences, vectorizer, vectors):
        self.texts = texts
        self.text = texts[0]
        self.sentences = sentences
        self.vectorizer = vectorizer
        self.vectors = vectors


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

    @classmethod
    def vectrize_for_test(cls, texts, tokenizer=None, vectorizer=None):
        # HACK: inject使えない?
        tokenizer = MecabTokenizer() if tokenizer is None else tokenizer
        vectorizer = TfidfVectorizer() if vectorizer is None else vectorizer
        sentences = tokenizer.tokenize(texts)
        vectors = vectorizer.fit_transform(sentences)
        return VectorizedValue(
            texts=texts,
            sentences=sentences,
            vectorizer=vectorizer,
            vectors=vectors,
        )
