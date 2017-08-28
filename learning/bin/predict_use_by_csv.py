import argparse

from learning.core.learn.learning_parameter import LearningParameter
from learning.core.predict.reply import Reply
from learning.log import logger
from myope_server import MyopeServer

parser = argparse.ArgumentParser()
parser.add_argument('--bot_id', default=13, type=int)  # bot_id = 13 は豊通
args = parser.parse_args()

body = 'プリンの話や'

attr = {
    'use_similarity_classification': True,
    'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION
}

learning_parameter = LearningParameter(attr)
result = Reply(args.bot_id, learning_parameter).perform([body], datasource_type='csv')
result.out_log_of_results()
