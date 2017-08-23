import argparse
from app.shared.config import Config
from app.shared.constants import Constants
from myope_server import MyopeServer

parser = argparse.ArgumentParser()
parser.add_argument('--bot_id', default=1, type=int)
parser.add_argument('--env', type=str, default='development')
parser.add_argument('--use_similarity_classification', type=str, default='true')
parser.add_argument('--algorithm', type=str, default=Constants.ALGORITHM_LOGISTIC_REGRESSION)
parser.add_argument('--datasource', type=str, default=Constants.DATASOURCE_TYPE_DATABASE)
args = parser.parse_args()
Config().init(args.env)

# FIXME: csvを使うと以下のエラーが出る
#        This solver needs samples of at least 2 classes in the data, but the data contains only one class: 0
attr = {
    'classify_threshold': None,
    'use_similarity_classification': args.use_similarity_classification == 'true',
    'algorithm': args.algorithm,
    'datasource_type': args.datasource,
    'params_for_algorithm': {},
}
myope_server = MyopeServer()
myope_server.learn(args.bot_id, attr)
