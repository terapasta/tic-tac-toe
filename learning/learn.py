from learning.core.learn.bot import Bot
from learning.core.learn.learning_parameter import LearningParameter

bot_id = 1
attr = {
    'include_failed_data': False,
    'include_tag_vector': True,
    'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION
}
learning_parameter = LearningParameter(attr)
evaluator = Bot(bot_id, learning_parameter).learn()
