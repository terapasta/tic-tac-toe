import argparse

from learning.core.learn.learning_parameter import LearningParameter
from learning.log import logger
from myope_server import MyopeServer

parser = argparse.ArgumentParser()
parser.add_argument('--bot_id', default=1, type=int)  # Rails側と重複しないIDを指定
args = parser.parse_args()

body = 'こんにちは。明日は何か予定がありますか？'

attr = {
    'include_failed_data': False,
    'include_tag_vector': False,
    'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION
}

myope_server = MyopeServer()
result = myope_server.reply(args.bot_id, body, attr)

logger.debug(result)