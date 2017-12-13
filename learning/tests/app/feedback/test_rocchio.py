from unittest import TestCase
from nose.tools import ok_

from app.feedback.rocchio_feedback import RocchioFeedback
from app.shared.datasource.datasource import Datasource
from tests.support.datasource.empty_question_answers import EmptyQuestionAnswers
from tests.support.helper import Helper, TextToVectorHelper


class RocchioTestCase(TestCase):
    def setUp(self):
        self.vec_helper = TextToVectorHelper.new()
        self.context = Helper.test_context(bot_id=1)

    def test_transform_query_vector_when_fitted(self):
        datasource = Datasource.new(question_answers=EmptyQuestionAnswers())

        instance = RocchioFeedback.new(
            bot=self.context.current_bot,
            datasource=datasource,
        )

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

        instance = RocchioFeedback.new(
            bot=self.context.current_bot,
            datasource=datasource,
        )

        query_vectors = self.vec_helper.vectorize(['らく賃について聞きたいのですが誰が担当なのかわかりますか?'])
        new_vectors = instance.transform_query_vector(query_vectors)

        ok_(len(list(new_vectors)) > 0)
