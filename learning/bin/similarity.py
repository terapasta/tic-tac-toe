from learning.core.predict.similarity import Similarity

bot_id = 1
question = 'オフィス'
result = Similarity(bot_id).question_answers(question)
print(result)