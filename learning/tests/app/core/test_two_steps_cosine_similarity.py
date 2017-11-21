from unittest import TestCase
from nose.tools import ok_

from app.shared.constants import Constants
from tests.support.helper import Helper

from app.core.two_steps_cosine_similarity import TwoStepsCosineSimilarity


class TwoStepsCosineSimilariryTestCase(TestCase):

    def test_initialize(self):
        context = Helper.test_context(bot_id=1, algorithm=Constants.ALGORITHM_TWO_STEP_SIMILARITY_CLASSIFICATION)
        TwoStepsCosineSimilarity.new(bot=context.current_bot)
        ok_(True)
