from unittest import TestCase
from nose.tools import ok_, eq_
import inject

from app.factories.two_step_cosine_similarity_factory import TwoStepCosineSimilarityFactory
from app.shared.config import Config
from app.shared.constants import Constants
from app.shared.current_bot import CurrentBot
from app.shared.datasource.datasource import Datasource
from app.controllers.learn_controller import LearnController
from app.factories.factory_selector import FactorySelector


class LearningParameter:
    datasource_type = Constants.DATASOURCE_TYPE_FILE
    use_similarity_classification = True
    algorithm = Constants.ALGORITHM_TWO_STEP_SIMILARITY_CLASSIFICATION


class TwoStepCosineSimilarityClassificationTestCase(TestCase):

    def setUp(self):
        inject.configure_once()
        Config().init('test')
        self.bot_id = 1
        self.learning_parameter = LearningParameter()
        self.body = '会社の住所が知りたい'

    def test_learn_and_reply(self):
        bot = CurrentBot().init(self.bot_id, self.learning_parameter)
        Datasource().init(bot)
        factory = FactorySelector().get_factory()

        eq_(factory.__class__.__name__, TwoStepCosineSimilarityFactory.__name__)

        LearnController(factory=factory).perform()

        # TODO
        # X = np.array([self.body])
        # ReplyController(factory=factory).perform(X[0])

        ok_(True)
