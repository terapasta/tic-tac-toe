from learning.core.predict.reply import Reply

bot_id = 1
X = [
    ['人生楽しいことがありますね、トマト食べたい']  # => ぼちぼちでんな
    # ['もりもり食べる']  # => ぼちぼちでんな
    # ['どんどん'],  # => 11
    # ['代表は誰？'],  # => 5
]

Reply(bot_id).predict(X)
