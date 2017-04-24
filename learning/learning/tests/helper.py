import pandas as pd
from nose.tools import eq_

from learning.core.learn.learning_parameter import LearningParameter


def learning_parameter(
        include_failed_data=False,
        include_tag_vector=False,
        algorithm=LearningParameter.ALGORITHM_LOGISTIC_REGRESSION,
        params_for_algorithm=None,
        use_similarity_classification=False
    ):
    return LearningParameter({
        'include_failed_data': include_failed_data,
        'include_tag_vector': include_tag_vector,
        'algorithm': algorithm,
        'params_for_algorithm': params_for_algorithm,
        'use_similarity_classification': use_similarity_classification
    })

def build_answers(csv_file_path, encoding='UTF-8'):
    learning_training_messages = pd.read_csv(csv_file_path, encoding=encoding)
    return learning_training_messages.drop_duplicates(subset=['answer_id'])

def get_answer_body(answers, answer_id):
    rows = answers.query('answer_id == %s' % answer_id)
    if rows.empty:
        return None
    return rows.iloc[0]['answer_body']

def replace_newline_and_space(val):
    return val.replace('\r\n', '').replace('\r', '').replace('\n', '').replace(' ', '')


