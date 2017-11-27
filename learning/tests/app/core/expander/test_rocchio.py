from unittest import TestCase
from nose.tools import ok_, assert_raises
from app.core.expander.rocchio import Rocchio
from app.shared.custom_errors import NotTrainedError
from tests.support.helper import Helper


class RocchioTestCase(TestCase):
    def test_initialize(self):
        Rocchio.new(datasource=Helper.empty_datasource())
        ok_(True)

    def test_fit(self):
        rocchio = Rocchio.new(datasource=Helper.empty_datasource())
        positive_docs = self._sentences
        value = Helper.vectorize_for_test(positive_docs)
        rocchio.fit(value.vectors, self._question_ids)

        # エラーにならないこと
        ok_(True)

    def test_predict_when_fitted(self):
        rocchio = Rocchio.new(datasource=Helper.empty_datasource())
        positive_docs = self._sentences
        value = Helper.vectorize_for_test(positive_docs)
        rocchio.fit(value.vectors, self._question_ids)

        query = Helper.vectorize_for_test(
            ['らく賃について聞きたいのですが誰が担当なのかわかりますか?'],
            value.tokenizer,
            value.vectorizer)
        vector = rocchio.predict(query.vectors)

        # Note: らく賃の担当者は誰。のベクターと一致すること
        ok_((vector != value.vectors[1]).nnz == 0)

    def test_predict_when_not_fitted(self):
        rocchio = Rocchio.new(datasource=Helper.empty_datasource())
        query = Helper.vectorize_for_test(['らく賃について聞きたいのですが誰が担当なのかわかりますか?'])

        def action():
            rocchio.predict(query.vectors)

        # 未学習エラーになること
        assert_raises(NotTrainedError, action)

    @property
    def _question_ids(self):
        return [12, 4, 5]

    @property
    def _sentences(self):
        return [
            '周辺商品でらく賃（受託）の担当者は誰。',
            'らく賃の担当者は誰。\n',
            '周辺商品でらく賃（申込）の担当者は誰。',
        ]
