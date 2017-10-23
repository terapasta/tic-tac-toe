from unittest import TestCase
import inject
import pandas as pd
from nose.tools import ok_, eq_

from app.core.estimator.word2vec_wmd import Word2vecWmd
from app.core.tokenizer.mecab_tokenizer import MecabTokenizer
from app.shared.app_status import AppStatus
from app.shared.config import Config
from app.shared.constants import Constants
from app.shared.datasource.datasource import Datasource
from app.shared.word2vec import Word2vec


class LearningParameter:
    datasource_type = Constants.DATASOURCE_TYPE_FILE
    algorithm = Constants.ALGORITHM_WORD2VEC_WMD

class Word2vecWmdTestCase(TestCase):

    def setUp(self):
        inject.configure_once()
        Config().init('test')
        self.bot_id = 1
        self.learning_parameter = LearningParameter()

    def test_predict(self):
        app_status = AppStatus().set_bot(self.bot_id, self.learning_parameter)
        Datasource().init(app_status.current_bot())
        Word2vec().init()
        tokenizer = MecabTokenizer()

        estimator = Word2vecWmd(tokenizer, Datasource(), bot=app_status.current_bot())
        result = estimator.predict(['田舎 ドンキホーテ'])

        # データが10件以下のオブジェクトが返ること
        ok_(len(result) <= 10)
        # DataFrameが返ること
        ok_(isinstance(result, pd.DataFrame))
