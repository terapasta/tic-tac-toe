from unittest import TestCase
from nose.tools import ok_, eq_
import inject
import numpy as np

from app.shared.config import Config
from app.shared.constants import Constants
from app.shared.app_status import AppStatus
from app.shared.datasource.datasource import Datasource
from app.controllers.reply_controller import ReplyController
from app.controllers.learn_controller import LearnController
from app.factories.factory_selector import FactorySelector
from app.factories.logistic_regression_factory import LogisticRegressionFactory


class LearningParameter:
    algorithm = Constants.ALGORITHM_LOGISTIC_REGRESSION


class LogisticRegressionTestCase(TestCase):

    def setUp(self):
        inject.configure_once()
        # Fixme:
        #     下記のエラーが出てしまう
        #     ```
        #     This solver needs samples of at least 2 classes in the data, but the data contains only one class: 0
        #     ```
        Config().init('test')
        Datasource().init(Constants.DATASOURCE_TYPE_FILE)
        self.bot_id = 1
        self.learning_parameter = LearningParameter()
        self.body = '会社の住所が知りたい'

    # def test_learn_and_reply(self):
        # app_status = AppStatus().set_bot(self.bot_id, self.learning_parameter)
        # factory = FactorySelector().get_factory()

        # eq_(factory.__class__.__name__, LogisticRegressionFactory.__name__)

        # LearnController(factory=factory).perform()

        # X = np.array([self.body])
        # ReplyController(factory=factory).perform(X[0])
        
        # app_status.thread_clear()

        # ok_(True)
