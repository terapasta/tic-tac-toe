import argparse

from learning.core.predict.similarity import Similarity

parser = argparse.ArgumentParser()
parser.add_argument('--bot_id', default=1, type=int)
args = parser.parse_args()

question = 'エラー'
result = Similarity(args.bot_id).question_answers(question).to_data()
print(result)
