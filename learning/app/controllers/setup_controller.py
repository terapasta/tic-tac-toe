from app.shared.on_memory_learning.word2vec_wmd_store import Word2vecWmdStore

from app.shared.datasource.datasource import Datasource
from app.shared.logger import logger
from app.shared.base_cls import BaseCls


class SetupController(BaseCls):
    def __init__(self):
        self.datasource = Datasource.new()

    def perform(self):
        logger.info('application initializing...')
        Word2vecWmdStore(question_answers=self.datasource.question_answers)
        logger.info('application initialized')
