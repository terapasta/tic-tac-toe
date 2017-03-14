from learning.core.learn.learning_parameter import LearningParameter
from myope_server import MyopeServer

bot_id = 5
body = 'セキュリティはどう'

attr = {
    'include_failed_data': False,
    'include_tag_vector': False,
    'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION
}

myope_server = MyopeServer()
myope_server.reply(bot_id, body, attr)