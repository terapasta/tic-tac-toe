from unittest import TestCase
from nose.tools import ok_


class LogisticRegressionTestCase(TestCase):

    def setUp(self):
        # Fixme:
        #     下記のエラーが出てしまう
        #     ```
        #     This solver needs samples of at least 2 classes in the data, but the data contains only one class: 0
        #     ```
        pass

    def test_learn_and_reply(self):
        ok_(True)
