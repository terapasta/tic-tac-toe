import argparse

from learning.config.config import Config
from learning.core.learn.learning_parameter import LearningParameter
from myope_server import MyopeServer

parser = argparse.ArgumentParser()
parser.add_argument('--bot_id', default=1, type=int)
parser.add_argument('--env', type=str, default='development')
args = parser.parse_args()
Config._ENV = args.env

attr = {
    'classify_threshold': None,
    # 'algorithm': LearningParameter.ALGORITHM_NAIVE_BAYES
    'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION,
    # 'params_for_algorithm': { 'C': 200 }
    'use_similarity_classification': True,
    'params_for_algorithm': {}

}
myope_server = MyopeServer()
myope_server.learn(args.bot_id, attr)
