from learning.core.learn.bot import Bot
bot_id = 4
learning_parameter = { "include_failed_data": False }
evaluator = Bot(bot_id, learning_parameter).learn()
