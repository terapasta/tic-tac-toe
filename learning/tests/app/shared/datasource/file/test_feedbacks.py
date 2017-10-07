from unittest import TestCase
from nose.tools import ok_


class FeedbacksTestCase(TestCase):

    # def setUp(self):
    #     inject.configure_once()
    #     Config().init('test')
    #     self.bot_id = 1
    #     self.learning_parameter = LearningParameter()
    #     self.body = '会社の住所が知りたい'

    def test_all(self):
        # data_builder = FeedbackDataBuilder()
        # datasource = Datasource()
        # data_builder.build(datasource)
        ok_(True)

        # bot = CurrentBot().init(self.bot_id, self.learning_parameter)
        # Datasource().init(bot)
        # factory = FactorySelector().get_factory()
        #
        # eq_(factory.__class__.__name__, CosineSimilarityFactory.__name__)
        #
        # LearnController(factory=factory).perform()
        #
        # X = np.array([self.body])
        # ReplyController(factory=factory).perform(X[0])
        #
        # ok_(True)
