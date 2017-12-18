from unittest import TestCase
from nose.tools import ok_
from tests.support.helper import Helper

from app.shared.constants import Constants
from app.shared.datasource.datasource import Datasource
from tests.support.datasource.empty_ratings import EmptyRatings
from app.controllers.reply_controller import ReplyController
from app.controllers.learn_controller import LearnController


class RocchioFeedbackTestCase(TestCase):

    def test_learn_and_reply(self):
        context = Helper.test_context(
            bot_id=1,
            algorithm=Constants.ALGORITHM_SIMILARITY_CLASSIFICATION,
            feedback_algorithm=Constants.FEEDBACK_ALGORITHM_ROCCHIO,
        )

        LearnController.new(context=context).perform()

        reply = ReplyController.new(context=context).perform('会社の住所が知りたい')

        # 結果が1件以上であること
        ok_(len(reply['results']) > 0)

    def test_learn_and_reply_when_no_rating(self):
        context = Helper.test_context(
            bot_id=1,
            algorithm=Constants.ALGORITHM_SIMILARITY_CLASSIFICATION,
            feedback_algorithm=Constants.FEEDBACK_ALGORITHM_ROCCHIO,
            datasource=Datasource.new(ratings=EmptyRatings()),
        )

        LearnController.new(context=context).perform()

        reply = ReplyController.new(context=context).perform('会社の住所が知りたい')

        # 結果が1件以上であること
        ok_(len(reply['results']) > 0)
