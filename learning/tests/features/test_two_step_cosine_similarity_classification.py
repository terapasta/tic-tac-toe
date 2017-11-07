from unittest import TestCase
from nose.tools import ok_
import numpy as np

from app.factories.two_step_cosine_similarity_factory import TwoStepCosineSimilarityFactory
from app.shared.constants import Constants
from app.controllers.learn_controller import LearnController
from app.controllers.reply_controller import ReplyController
from tests.support.test_datasource import TestDatasource
from tests.support.helper import Helper


class TwoStepCosineSimilarityClassificationTestCase(TestCase):

    def setUp(self):
        Helper.init(bot_id=1, algorithm=Constants.ALGORITHM_TWO_STEP_SIMILARITY_CLASSIFICATION)

    def test_learn_and_reply(self):
        factory = TwoStepCosineSimilarityFactory(datasource=TestDatasource())

        LearnController(factory=factory).perform()

        X = np.array(['ここからどれくらいかかりますか'])
        ReplyController(factory=factory).perform(X[0])

        ok_(True)
