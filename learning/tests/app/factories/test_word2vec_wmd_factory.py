from unittest import TestCase
import inject
import pandas as pd
from nose.tools import ok_, eq_

from app.core.estimator.word2vec_wmd import Word2vecWmd
from app.core.tokenizer.mecab_tokenizer import MecabTokenizer
from app.factories.word2vec_wmd_factory import Word2vecWmdFactory
from app.shared.config import Config
from app.shared.constants import Constants
from app.shared.current_bot import CurrentBot
from app.shared.datasource.datasource import Datasource


class LearningParameter:
    datasource_type = Constants.DATASOURCE_TYPE_FILE
    algorithm = Constants.ALGORITHM_WORD2VEC_WMD

class Word2vecWmdFactoryTestCase(TestCase):

    def setUp(self):
        inject.configure_once()
        Config().init('test')
        self.bot_id = 1
        self.learning_parameter = LearningParameter()

    def test_init(self):
        bot = CurrentBot().init(self.bot_id, self.learning_parameter)
        Datasource().init(bot)
        Word2vecWmdFactory()
        ok_(True)