from learning.core.predict.reply import Reply

bot_id = 4
X = [
    # ['セキュリティーはどうなっている？'],
    # ['セキュリティーはどう？'],
    ['こんにちは'],
]

Reply(bot_id).predict(X)
