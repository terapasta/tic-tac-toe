from unittest import TestCase
from nose.tools import ok_, assert_raises
from app.core.estimator.rocchio import Rocchio
from app.shared.custom_errors import NotTrainedError
from tests.support.helper import Helper, TextToVectorHelper


class RocchioTestCase(TestCase):
    def setUp(self):
        self.vec_helper = TextToVectorHelper.new()

    def test_initialize(self):
        Rocchio.new(datasource=Helper.empty_datasource())
        ok_(True)

    def test_fit(self):
        rocchio = Rocchio.new(datasource=Helper.empty_datasource())
        positive_docs = self._sentences
        vectors = self.vec_helper.vectorize(positive_docs)
        rocchio.fit(vectors, self._question_ids)

        # エラーにならないこと
        ok_(True)

    def test_predict_when_fitted(self):
        rocchio = Rocchio.new(datasource=Helper.empty_datasource())
        positive_docs = self._sentences
        vectors = self.vec_helper.vectorize(positive_docs)
        rocchio.fit(vectors, self._question_ids)

        query_vectors = self.vec_helper.vectorize(['らく賃について聞きたいのですが誰が担当なのかわかりますか?'])

        result = rocchio.predict(query_vectors)

        ok_(len(result['question_answer_id']) > 0)

    def test_predict_when_not_fitted(self):
        rocchio = Rocchio.new(datasource=Helper.empty_datasource())
        query_vectors = self.vec_helper.vectorize(['らく賃について聞きたいのですが誰が担当なのかわかりますか?'])

        def action():
            rocchio.predict(query_vectors)

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
