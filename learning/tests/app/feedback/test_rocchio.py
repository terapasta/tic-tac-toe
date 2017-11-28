from unittest import TestCase
from nose.tools import ok_

from app.core.estimator.rocchio import Rocchio as RocchioEstimator
from app.feedback.rocchio import Rocchio
from app.shared.datasource.datasource import Datasource
from tests.support.datasource.empty_question_answers import EmptyQuestionAnswers
from tests.support.helper import TextToVectorHelper


class RocchioTestCase(TestCase):
    def setUp(self):
        self.vec_helper = TextToVectorHelper.new()

    def test_transform_query_vector_when_fitted(self):
        datasource = Datasource.new(question_answers=EmptyQuestionAnswers())

        instance = Rocchio.new(
            estimator_for_good=RocchioEstimator.new(datasource=datasource, dump_key='sk_rocchio_good'),
            estimator_for_bad=RocchioEstimator.new(datasource=datasource, dump_key='sk_rocchio_bad'),
            datasource=datasource,
        )
        self.vec_helper = TextToVectorHelper.new()

        positive_vectors = self.vec_helper.vectorize([
            '周辺商品でらく賃（受託）の担当者は誰。',
            'らく賃の担当者は誰。\n',
            '周辺商品でらく賃（申込）の担当者は誰。',
        ])
        instance.fit_for_good(positive_vectors, [10791, 10859, 10792])

        negative_vectors = self.vec_helper.vectorize([
            '救急箱の担当は誰。',
            'ちょっと聞きたい',
            'わからない',
        ])
        instance.fit_for_bad(negative_vectors, [10860, 10674, 10617])

        query_vectors = self.vec_helper.vectorize(['らく賃について聞きたいのですが誰が担当なのかわかりますか?'])
        new_vectors = instance.transform_query_vector(query_vectors)

        ok_(len(list(new_vectors)) > 0)

    def test_transform_query_vector_when_not_fitted(self):
        datasource = Datasource.new(question_answers=EmptyQuestionAnswers())

        instance = Rocchio.new(
            estimator_for_good=RocchioEstimator.new(datasource=datasource, dump_key='sk_rocchio_good_not_fitted'),
            estimator_for_bad=RocchioEstimator.new(datasource=datasource, dump_key='sk_rocchio_bad_not_fitted'),
            datasource=datasource,
        )

        query_vectors = self.vec_helper.vectorize(['らく賃について聞きたいのですが誰が担当なのかわかりますか?'])
        new_vectors = instance.transform_query_vector(query_vectors)

        ok_(len(list(new_vectors)) > 0)
