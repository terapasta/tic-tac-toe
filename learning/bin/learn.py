import argparse
from app.shared.config import Config
from app.shared.constants import Constants
from myope_server import MyopeServer

parser = argparse.ArgumentParser()
parser.add_argument('--bot_id', default=1, type=int)
parser.add_argument('--env', type=str, default='development')
args = parser.parse_args()
Config().init(args.env)

attr = {
    'classify_threshold': None,
    'algorithm': Constants.ALGORITHM_LOGISTIC_REGRESSION,
    'use_similarity_classification': True,
    'params_for_algorithm': {},
}
myope_server = MyopeServer()
myope_server.learn(args.bot_id, attr)
