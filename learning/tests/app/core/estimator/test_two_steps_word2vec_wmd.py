from unittest import TestCase
import inject
from nose.tools import ok_, eq_

from app.core.estimator.two_steps_word2vec_wmd import TwoStepsWord2vecWmd
from app.core.tokenizer.mecab_tokenizer_with_split import MecabTokenizerWithSplit
from app.shared.config import Config
from app.shared.constants import Constants
from app.shared.datasource.datasource import Datasource


class LearningParameter:
    algorithm = Constants.ALGORITHM_WORD2VEC_WMD


class TwoStepsWord2vecWmdTestCase(TestCase):

    def setUp(self):
        inject.configure_once()
        Config().init('test')
        Datasource().init(datasource_type=Constants.DATASOURCE_TYPE_FILE)
        self.bot_id = 9
        self.learning_parameter = LearningParameter()

    def test__tokenize_with_qaid(self):
        tokenizer = MecabTokenizerWithSplit()

        estimator = TwoStepsWord2vecWmd(tokenizer, Datasource())
        result = estimator._tokenize_with_qaid(['田舎 ドンキホーテ', '都会　ドンキホーテ'], [100, 200])

        # QAIDが付与されること
        eq_(list(result[0]), ['田舎', 'ドンキホーテ', 'MYOPE_QA_ID:100'])

        # datasourceのデータでもエラーにならないこと
        qas = Datasource().question_answers.by_bot(self.bot_id)
        result = estimator._tokenize_with_qaid(qas['question'], qas['question_answer_id'].astype(int))

        # 空でもエラーにならないこと
        result = estimator._tokenize_with_qaid([], [])

        # データが10件以下のオブジェクトが返ること
        ok_(True)
