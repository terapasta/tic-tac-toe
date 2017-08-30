from unittest import TestCase
from nose.tools import ok_, eq_
import inject
import numpy as np

from app.shared.config import Config
from app.shared.constants import Constants
from app.shared.current_bot import CurrentBot
from app.controllers.reply_controller import ReplyController
from app.controllers.learn_controller import LearnController
from app.factories.factory_selector import FactorySelector
from app.factories.cosine_similarity_factory import CosineSimilarityFactory


class CosineSimilarityClassificationTestCase(TestCase):

    def setUp(self):
        inject.configure_once()
        Config().init('test')
        self.bot_id = 1
        self.learning_parameter = {
          'datasource_type': Constants.DATASOURCE_TYPE_CSV,
          'use_similarity_classification': True,
          'algorithm': Constants.ALGORITHM_SIMILARITY_CLASSIFICATION,
        }
        self.body = '会社の住所が知りたい'

    def test_learn_and_reply(self):
        CurrentBot().init(self.bot_id, self.learning_parameter)
        factory = FactorySelector().get_factory()

        eq_(factory.__class__.__name__, CosineSimilarityFactory.__name__)

        LearnController(factory=factory).perform()

        X = np.array([self.body])
        ReplyController(factory=factory).perform(X[0])

        ok_(True)
