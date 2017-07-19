import pandas as pd
from nose.tools import eq_

from learning.core.learn.learning_parameter import LearningParameter


def learning_parameter(
        include_failed_data=False,
        include_tag_vector=False,
        algorithm=LearningParameter.ALGORITHM_LOGISTIC_REGRESSION,
        params_for_algorithm=None,
        use_similarity_classification=True
    ):
    return LearningParameter({
        'include_failed_data': include_failed_data,
        'include_tag_vector': include_tag_vector,
        'algorithm': algorithm,
        'params_for_algorithm': params_for_algorithm,
        'use_similarity_classification': use_similarity_classification
    })

def build_question_answers(csv_file_path, encoding='UTF-8'):
    return pd.read_csv(csv_file_path, encoding=encoding)

def get_answer(question_answers, id):
    rows = question_answers.query('question_answer_id == %s' % id)
    if rows.empty:
        return None
    return rows.iloc[0]['answer']

def replace_newline_and_space(val):
    return val.replace('\r\n', '').replace('\r', '').replace('\n', '').replace(' ', '')


