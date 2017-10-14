from unittest import TestCase
#
# import inject
# import numpy as np
import inject
from nose.tools import ok_, eq_
#
# from app.core.vectorizer.word2vec_vectorizer import Word2vecVectorizer
# from app.shared.config import Config
# from app.shared.constants import Constants
# from app.shared.current_bot import CurrentBot
# from app.shared.datasource.datasource import Datasource
#
#
# class LearningParameter:
#     datasource_type = Constants.DATASOURCE_TYPE_FILE
#     # use_similarity_classification = True
#     algorithm = Constants.ALGORITHM_WORD2VEC_WMD
#
#
from app.core.estimator.word_movers_distance import WordMoversDistance


class WordMoversDistanceTestCase(TestCase):

    def setUp(self):
        inject.configure_once()
#
#         Config().init('test')
#         self.bot_id = 1
#         self.learning_parameter = LearningParameter()
#
    def test_predict(self):
#         bot = CurrentBot().init(self.bot_id, self.learning_parameter)
#         Datasource().init(bot)
#
        estimator = WordMoversDistance(None, None, None, None, None)
        estimator.predict(['hoge moge fuga'])
#         vectorizer.transform(['hoge', 'moge'])
#         # vectorizer.fit(np.array(['hoge', 'moge', 'hage']))
#
        ok_(True)
