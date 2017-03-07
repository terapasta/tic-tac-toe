from learning.core.learn.bot import Bot
from learning.core.learn.learning_parameter import LearningParameter

bot_id = 1
attr = {
    'include_failed_data': False,
    'include_tag_vector': False,
    'classify_threshold': None,
    # 'algorithm': LearningParameter.ALGORITHM_NAIVE_BAYES
    'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION,
    # 'params_for_algorithm': { 'C': 200 }
    'params_for_algorithm': {}

}
learning_parameter = LearningParameter(attr)
evaluator = Bot(bot_id, learning_parameter).learn()
