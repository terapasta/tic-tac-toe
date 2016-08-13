from ..core.predict.helpdesk_classify import HelpdeskClassify

bot_id = 2
X = [
    #['カードなくした'],
    ['出張費']
]

print(HelpdeskClassify(bot_id).predict(X))
