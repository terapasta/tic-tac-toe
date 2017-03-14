from learning.core.learn.learning_parameter import LearningParameter
from myope_server import MyopeServer

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
myope_server = MyopeServer()
myope_server.learn(bot_id, attr)