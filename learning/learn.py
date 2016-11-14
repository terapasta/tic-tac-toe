from learning.core.learn.bot import Bot
bot_id = 1
learning_parameter = { "include_failed_data": True }
evaluator = Bot(bot_id, learning_parameter).learn()
