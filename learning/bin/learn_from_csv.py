import argparse

from learning.core.learn.bot import Bot
from learning.core.learn.learning_parameter import LearningParameter

parser = argparse.ArgumentParser()
parser.add_argument('--bot_id', default=1001, type=int)  # Rails側と重複しないIDを指定
args = parser.parse_args()

attr = {
    'include_failed_data': False,
    'include_tag_vector': False,
    'classify_threshold': None,
    'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION,
    'params_for_algorithm': {}
}
learning_parameter = LearningParameter(attr)
_evaluator = Bot(args.bot_id, learning_parameter).learn(csv_file_path='bin/files/septeni.csv')