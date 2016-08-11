# -*- coding: utf-8 -
from ..core.predict.reply import Reply

bot_id = 1
X = [
    ['会社のミッションは？'],  # => 11
    # ['ミッション'],  # => 11
    # ['代表は誰？'],  # => 5
]

print(Reply(bot_id).predict(X))
