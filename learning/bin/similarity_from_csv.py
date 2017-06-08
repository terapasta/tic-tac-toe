import argparse

from learning.core.predict.similarity import Similarity

parser = argparse.ArgumentParser()
parser.add_argument('--bot_id', default=13, type=int)  # bot_id = 13 は豊通
args = parser.parse_args()

question = 'エラー'
result = Similarity(args.bot_id).question_answers(question, datasource_type='csv').to_data()
print(result)
