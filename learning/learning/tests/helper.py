import pandas as pd
from nose.tools import eq_

def build_answers(csv_file_path, encoding='UTF-8'):
    learning_training_messages = pd.read_csv(csv_file_path, encoding=encoding)
    return learning_training_messages.drop_duplicates(subset=['answer_id'])

def get_answer_body(answers, answer_id):
    rows = answers.query('answer_id == %s' % answer_id)
    return rows.iloc[0]['answer_body']

def replace_newline(val):
    val.replace('\r\n', '').replace('\r', '').replace('\n', '')


