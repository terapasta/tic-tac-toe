from unittest import TestCase
import pandas as pd
from nose.tools import ok_, assert_raises

from app.core.hybrid_classification import HybridClassification
from app.core.estimator.naive_bayes import NaiveBayes
from app.core.estimator.logistic_regression import LogisticRegression
from app.shared.datasource.datasource import Datasource
from app.shared.constants import Constants
from tests.support.helper import Helper
from tests.support.datasource.empty_question_answers import EmptyQuestionAnswers


class HybridClassificationTestCase(TestCase):

    def setUp(self):
        context = Helper.test_context(bot_id=1, algorithm=Constants.ALGORITHM_HYBRID_CLASSIFICATION)
        self.bot = context.current_bot
        self.question = Helper().vectrize_for_test(['田舎のドンキホーテは賑わってる?'])

    def test_predict(self):
        hc = HybridClassification.new(bot=self.bot, vectorizer=self.question.vectorizer)
        result = hc.predict(self.question.vectors)

        # DataFrameが返ること
        ok_(isinstance(result, pd.DataFrame))

    def test_predict_when_data_is_empty(self):
        # データが存在しない場合
        datasource = Datasource(question_answers=EmptyQuestionAnswers())
        hc = HybridClassification.new(bot=self.bot, datasource=datasource)
        hc.predict([])

        # エラーにならないこと
        ok_(True)

    def test_after_reply_by_naive_bayes(self):
        estimator = NaiveBayes.new()
        most_similar = self.__after_reply(estimator)[0]

        # probabilityが加算されること
        ok_(most_similar['probability'] > 0.6)

    def test_after_reply_by_logistic_regression(self):
        estimator = LogisticRegression.new()

        def action():
            self.__after_reply(estimator)

        # クラス毎のサンプル数が足りないためエラーになる(各クラス3サンプル以上あれば大丈夫)
        assert_raises(ValueError, action)

    def __after_reply(self, estimator):
        answers = Helper.vectrize_for_test([
            '田舎のヤンキーはコンビニの前に座ってるの', 'コンビニのゴミ箱には捨ててはいけない', 'どんどんどんドンキホーテ',
            'うんち', 'ふがふが', 'よちよち',
            'あかちゃんはハイハイする', 'おかあさんと一緒', 'お義父さんは芝刈りにいきました',
        ])
        answer_ids = [
            100, 200, 300,
            400, 500, 600,
            700, 800, 900,
        ]
        estimator.fit(answers.vectors, answer_ids)
        hc = HybridClassification.new(bot=self.bot, vectorizer=answers.vectorizer, estimator=estimator)
        first_step_result = pd.DataFrame({
            'question': ['賑わってる', 'うんちブリブリ', 'ヤンキーくんはメガネをかけている'],
            'question_answer_id': [300, 400, 100],
            'probability': [0.6, 0.2, 0.1],
        })
        results = hc.after_reply(self.question.text, first_step_result)
        results = results.sort_values(by='probability', ascending=False)
        results = results.to_dict('records')[:10]

        return results
