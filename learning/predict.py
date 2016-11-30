from learning.core.predict.reply import Reply

bot_id = 6
X = [
    ['セキュリティーはどうなっている？'],
    ['セキュリティーはどう？'],
    # ['アイスいる？'],
]

Reply(bot_id).predict(X)
