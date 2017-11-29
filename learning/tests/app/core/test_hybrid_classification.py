from unittest import TestCase
import pandas as pd
from nose.tools import ok_, assert_raises

from app.core.hybrid_classification import HybridClassification
from app.core.estimator.naive_bayes import NaiveBayes
from app.core.estimator.logistic_regression import LogisticRegression
from app.shared.datasource.datasource import Datasource
from app.shared.constants import Constants
from tests.support.helper import Helper, TextToVectorHelper
from tests.support.datasource.empty_question_answers import EmptyQuestionAnswers


class HybridClassificationTestCase(TestCase):

    def setUp(self):
        context = Helper.test_context(bot_id=1, algorithm=Constants.ALGORITHM_HYBRID_CLASSIFICATION)
        self.bot = context.current_bot
        self.vec_helper = TextToVectorHelper.new()
        self.question_text = '田舎のドンキホーテは賑わってる?'
        self.question_vectors = self.vec_helper.vectorize([self.question_text])

    def test_predict(self):
        hc = HybridClassification.new(bot=self.bot, vectorizer=self.vec_helper.vectorizer)
        result = hc.predict(self.question_vectors)

        # DataFrameが返ること
        ok_(isinstance(result, pd.DataFrame))

    def test_predict_when_data_is_empty(self):
        # データが存在しない場合
        datasource = Datasource.new(question_answers=EmptyQuestionAnswers())
        hc = HybridClassification.new(bot=self.bot, datasource=datasource)
        hc.predict([])

        # エラーにならないこと
        ok_(True)

    def test_after_reply(self):
        class NaiveBayesTest:
            def predict(self, x):
                return pd.DataFrame({
                    'question_answer_id': [300, 400, 100],
                    'probability': [0.3, 0.1, 0.1],
                })
        estimator = NaiveBayesTest()
        most_similar = self.__after_reply(estimator)[0]

        # probabilityが加算されること
        ok_(most_similar['probability'] > 0.6)

    def __after_reply(self, estimator):
        hc = HybridClassification.new(bot=self.bot, vectorizer=self.vec_helper.vectorizer, estimator=estimator)
        first_step_result = pd.DataFrame({
            'question': ['賑わってる', 'うんちブリブリ', 'ヤンキーくんはメガネをかけている'],
            'question_answer_id': [300, 400, 100],
            'probability': [0.6, 0.2, 0.1],
        })
        results = hc.after_reply(self.question_text, first_step_result)
        results = results.sort_values(by='probability', ascending=False)
        results = results.to_dict('records')[:10]

        return results
