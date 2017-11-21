from app.core.tokenizer.mecab_tokenizer import MecabTokenizer
from app.core.vectorizer.tfidf_vectorizer import TfidfVectorizer
from app.shared.config import Config
from app.shared.context import Context
from app.shared.datasource.datasource import Datasource
from tests.support.datasource.empty_persistence import EmptyPersistence
from tests.support.datasource.empty_question_answers import EmptyQuestionAnswers
from tests.support.datasource.empty_ratings import EmptyRatings


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
    def init(cls):
        Config().init('test')

    @classmethod
    def test_context(cls, bot_id, algorithm):
        return Context(bot_id, LearningParameter(algorithm=algorithm), {})

    @classmethod
    def empty_datasource(cls):
        return Datasource(
            persistence=EmptyPersistence(),
            question_answers=EmptyQuestionAnswers(),
            ratings=EmptyRatings(),
        )

    @classmethod
    def vectrize_for_test(cls, texts, tokenizer=None, vectorizer=None):
        tokenizer = MecabTokenizer.new() if tokenizer is None else tokenizer
        vectorizer = TfidfVectorizer.new() if vectorizer is None else vectorizer
        sentences = tokenizer.tokenize(texts)
        vectors = vectorizer.fit_transform(sentences)
        return VectorizedValue(
            texts=texts,
            sentences=sentences,
            vectorizer=vectorizer,
            vectors=vectors,
        )
