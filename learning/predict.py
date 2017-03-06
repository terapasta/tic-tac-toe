from learning.core.predict.reply import Reply
from learning.core.learn.learning_parameter import LearningParameter

bot_id = 5

X = [
    'セキュリティはどう？',
    # 'セキュリティはどうなってる？',
    # 'どんな会社が使ってる？',
    # '何歳ですか？',
    # 'サーバーはどこ使ってるの？',
    # 'ECサイトでも使えますか？',
    # 'どんな質問ならいける？',
    # 'クラウドサービスですか？',
    # '管理画面のサンプルがみたいす',
    # 'デモサイトはありますか？',
]

attr = {
    'include_failed_data': False,
    'include_tag_vector': False,
    'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION
}
learning_parameter = LearningParameter(attr)
reply_result = Reply(bot_id, learning_parameter).perform(X)
reply_result.to_dict()
