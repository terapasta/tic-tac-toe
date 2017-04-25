import argparse

from learning.core.learn.bot import Bot
from learning.core.learn.learning_parameter import LearningParameter

parser = argparse.ArgumentParser()
parser.add_argument('--bot_id', default=1001, type=int, help='Rails側と重複しないIDを指定')
parser.add_argument('--classify_threshold', default=None, type=float, help='正解とみなす確率のしきい値を 0.0 - 1.0 の間の値で指定')
parser.add_argument('--excluded_labels_for_fitting', nargs='+', default=None, type=int, help='学習時に除外したいラベルを１つ以上指定')
args = parser.parse_args()

attr = {
    'include_failed_data': False,
    'include_tag_vector': False,
    'classify_threshold': args.classify_threshold,
    'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION,
    'params_for_algorithm': {},
    'excluded_labels_for_fitting': args.excluded_labels_for_fitting
}
learning_parameter = LearningParameter(attr)
_evaluator = Bot(args.bot_id, learning_parameter).learn(csv_file_path='bin/files/toyotsu_human.csv')