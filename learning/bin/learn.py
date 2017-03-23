import argparse

from learning.core.learn.learning_parameter import LearningParameter
from myope_server import MyopeServer

parser = argparse.ArgumentParser()
parser.add_argument('--bot_id', default=1, type=int)
args = parser.parse_args()

attr = {
    'include_failed_data': False,
    'include_tag_vector': False,
    'classify_threshold': None,
    # 'algorithm': LearningParameter.ALGORITHM_NAIVE_BAYES
    'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION,
    # 'params_for_algorithm': { 'C': 200 }
    'params_for_algorithm': {}

}
myope_server = MyopeServer()
myope_server.learn(args.bot_id, attr)