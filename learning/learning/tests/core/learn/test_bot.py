# -*- coding: utf-8 -
import unittest
# import numpy as np
from ....core.learn.bot import Bot

class TestBot(unittest.TestCase):

    def test_learn(self):
        result = Bot().learn()
        print result
        self.assertIsInstance(result, float)

if __name__ == '__main__':
    unittest.main()
