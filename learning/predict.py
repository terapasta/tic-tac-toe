from learning.core.predict.reply import Reply
from learning.core.learn.learning_parameter import LearningParameter

bot_id = 6
X = [
    # ['どんな会社が使ってる？'],
    # ['何歳ですか？'],
    # ['セキュリティはどう？'],
    # ['サーバはどこ使ってますか？'],
    ['サーバはどこ使ってる？'],
    # ['サーバはどうなっている？'],
    # ['セキュリティーはどうなっている？'],
]

attr = {
    'include_failed_data': False,
    'include_tag_vector': False,
    'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION
}
learning_parameter = LearningParameter(attr)
Reply(bot_id, learning_parameter).predict(X)
