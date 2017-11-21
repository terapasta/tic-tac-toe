import pandas as pd
from app.shared.base_cls import BaseCls


# Note: csvのデータを使いquestionとanswerを取得する
#       結果dataframeにquestion_id, question の2つのカラムが必要
#       (csvの1行目に上記の列名を含めること)
class QuestionAnswers(BaseCls):
    def __init__(self):
        self._data = pd.read_csv('./fixtures/learning_training_messages.csv')

    def all(self):
        return self._data

    def by_bot(self, bot_id):
        return self._data[self._data['bot_id'] == bot_id]
