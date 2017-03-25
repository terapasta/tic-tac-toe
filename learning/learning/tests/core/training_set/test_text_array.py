import numpy as np
import scipy

from learning.core.persistance import Persistance
from unittest import TestCase
from nose.tools import ok_, eq_

from learning.core.training_set.text_array import TextArray


class TextArrayTestCase(TestCase):

    def test_to_vec(self):
        X = np.array([
            'こんにちは、元気ですか？',
            '私は元気にしています',
            'あなたの名前を教えてください'
        ])
        text_array = TextArray(X)
        vec = text_array.to_vec()

        # 3x7のスパース行列であること
        ok_(isinstance(vec, scipy.sparse.csr.csr_matrix))
        eq_(vec.shape, (3, 7))

    def test_except_blank(self):
        X = np.array([
            '',
            'こんにちは、元気ですか？',
            '',
            'あなたの名前を教えてください'
        ])
        text_array = TextArray(X)
        excepted_indexes = text_array.except_blank()

        # 除外されたインデックス0,2が返ること
        eq_(excepted_indexes, [0, 2])
        # データが削除されて2件になること
        eq_(len(text_array.sentences), 2)
        eq_(len(text_array.separated_sentences), 2)
