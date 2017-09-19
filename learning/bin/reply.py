import argparse

from app.shared.logger import logger
from app.shared.config import Config
from app.shared.constants import Constants
from myope_server import MyopeServer

parser = argparse.ArgumentParser()
parser.add_argument('--bot_id', default=1, type=int)  # Rails側と重複しないIDを指定
parser.add_argument('--env', type=str, default='development')
parser.add_argument('--question', type=str, default='プリンの話や')
parser.add_argument('--use_similarity_classification', type=str, default='true')
parser.add_argument('--algorithm', type=str, default=Constants.ALGORITHM_LOGISTIC_REGRESSION)
parser.add_argument('--datasource', type=str, default=Constants.DATASOURCE_TYPE_DATABASE)
args = parser.parse_args()
Config().init(args.env)

attr = {
    'use_similarity_classification': args.use_similarity_classification == 'true',
    'algorithm': args.algorithm,
    'datasource_type': args.datasource,
}

myope_server = MyopeServer()
result = myope_server.reply(args.bot_id, args.question, attr)

logger.debug(result)
