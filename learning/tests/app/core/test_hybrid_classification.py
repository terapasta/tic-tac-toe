from unittest import TestCase
import pandas as pd
from nose.tools import ok_

from app.core.hybrid_classification import HybridClassification
from app.core.estimator.naive_bayes import NaiveBayes
from app.shared.constants import Constants
from app.shared.datasource.datasource import Datasource
from tests.support.helper import Helper
from tests.support.datasource.empty_question_answers import EmptyQuestionAnswers


class HybridClassificationTestCase(TestCase):

    def setUp(self):
        Helper.init(bot_id=1, algorithm=Constants.ALGORITHM_WORD2VEC_WMD)
        self.question = Helper().vectrize_for_test(['田舎のドンキホーテは賑わってる?'])

    def test_predict(self):
        hc = HybridClassification(vectorizer=self.question.vectorizer)
        result = hc.predict(self.question.vectors)

        # DataFrameが返ること
        ok_(isinstance(result, pd.DataFrame))

    def test_predict_when_data_is_empty(self):
        # データが存在しない場合
        datasource = Datasource(question_answers=EmptyQuestionAnswers)
        hc = HybridClassification(datasource=datasource)
        hc.predict([])

        # エラーにならないこと
        ok_(True)

    def test_after_reply(self):
        answers = Helper.vectrize_for_test([
            '田舎のヤンキーはコンビニの前に座ってるの', 'コンビニのゴミ箱には捨てては行けない', 'どんどんどんドンキホーテ',
            'うんち', 'ふがふが', 'よちよち',
            'あかちゃんはハイハイする', 'おかあさんと一緒', 'お義父さんは芝刈りにいきました',
        ])
        answer_ids = [
            100, 200, 300,
            400, 500, 600,
            700, 800, 900,
        ]
        estimator = NaiveBayes()
        estimator.fit(answers.vectors, answer_ids)
        hc = HybridClassification(vectorizer=answers.vectorizer, estimator=estimator)
        first_step_result = pd.DataFrame({
            'question': ['賑わってる'],
            'question_answer_id': [100],
            'probability': [0.6],
        })
        results = hc.after_reply(self.question.text, first_step_result)
        most_similar = results[0]

        # probabilityが加算されること
        ok_(most_similar['probability'] > 0.6)
