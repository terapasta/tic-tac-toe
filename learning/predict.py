from learning.core.predict.reply import Reply
from learning.core.learn.learning_parameter import LearningParameter

bot_id = 4
X = [
    # ['セキュリティーはどうなっている？'],
    # ['セキュリティーはどう？'],
    ['こんにちは'],
]

attr = {
    'include_failed_data': False,
    'include_tag_vector': False,
    'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION
}
learning_parameter = LearningParameter(attr)
Reply(bot_id, learning_parameter).predict(X)
