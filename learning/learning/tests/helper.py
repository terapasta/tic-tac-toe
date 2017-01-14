import pandas as pd

def build_answers(csv_file_path, encoding='UTF-8'):
    learning_training_messages = pd.read_csv(csv_file_path, encoding=encoding)
    return learning_training_messages.drop_duplicates(subset=['answer_id'])

