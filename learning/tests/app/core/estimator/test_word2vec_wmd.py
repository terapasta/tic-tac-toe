from unittest import TestCase
import inject
import pandas as pd
from nose.tools import ok_

from app.core.estimator.word2vec_wmd import Word2vecWmd
from app.core.tokenizer.mecab_tokenizer_with_split import MecabTokenizerWithSplit
from app.shared.config import Config
from app.shared.constants import Constants
from app.shared.app_status import AppStatus
from app.shared.datasource.datasource import Datasource


class LearningParameter:
    algorithm = Constants.ALGORITHM_WORD2VEC_WMD


class Word2vecWmdTestCase(TestCase):

    def setUp(self):
        inject.configure_once()
        Config().init('test')
        Datasource().init(datasource_type=Constants.DATASOURCE_TYPE_FILE)
        AppStatus().set_bot(bot_id=1, learning_parameter=LearningParameter())

    def test_predict(self):
        tokenizer = MecabTokenizerWithSplit()

        estimator = Word2vecWmd(tokenizer, Datasource())
        result = estimator.predict(['田舎 ドンキホーテ'])

        # データが10件以下のオブジェクトが返ること
        ok_(len(result) <= 10)
        # DataFrameが返ること
        ok_(isinstance(result, pd.DataFrame))
