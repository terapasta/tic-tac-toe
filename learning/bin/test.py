import argparse
import pandas as pd
import numpy as np

from app.shared.config import Config
from app.shared.datasource.database.question_answers import QuestionAnswers

parser = argparse.ArgumentParser()
parser.add_argument('--env', type=str, default='development')
args = parser.parse_args()

Config().init(args.env)

question_answers = QuestionAnswers()
all_question_answers = question_answers.all()

print(all_question_answers)
