import argparse

from learning.config.config import Config
from learning.core.predict.similarity import Similarity

parser = argparse.ArgumentParser()
parser.add_argument('--bot_id', default=1, type=int)
parser.add_argument('--env', type=str, default='development')
args = parser.parse_args()
Config._ENV = args.env


question = 'エラー'
result = Similarity(args.bot_id).question_answers(question).to_data_frame()
print(result)
