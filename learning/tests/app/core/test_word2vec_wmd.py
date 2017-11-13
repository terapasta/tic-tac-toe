from unittest import TestCase
import pandas as pd
from nose.tools import ok_

from app.core.word2vec_wmd import Word2vecWmd
from app.shared.constants import Constants
from tests.support.helper import Helper


class Word2vecWmdTestCase(TestCase):

    def setUp(self):
        Helper.init(bot_id=1, algorithm=Constants.ALGORITHM_WORD2VEC_WMD)

    def test_predict(self):
        estimator = Word2vecWmd()
        result = estimator.predict(['田舎 ドンキホーテ'])

        # データが10件以下のオブジェクトが返ること
        ok_(len(result) <= 10)
        # DataFrameが返ること
        ok_(isinstance(result, pd.DataFrame))
