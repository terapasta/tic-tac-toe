from learning.core.learn.bot import Bot
from learning.core.learn.learning_parameter import LearningParameter

bot_id = 1001  # Rails側と重複しないIDを指定
attr = {
    'include_failed_data': False,
    'include_tag_vector': False,
    'classify_threshold': None,
    'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION,
    'params_for_algorithm': {}
}
learning_parameter = LearningParameter(attr)
_evaluator = Bot(bot_id, learning_parameter).learn(csv_file_path='bin/files/septeni.csv')