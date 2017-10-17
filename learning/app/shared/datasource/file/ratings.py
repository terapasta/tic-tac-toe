import pandas as pd


class Ratings:
    def __init__(self):
        self._data = pd.read_csv('./fixtures/ratings.csv')

    def all(self):
        return self._data

    def by_bot(self, bot_id):
        return self._data[self._data['bot_id'] == bot_id]

    def higher_rate_by_bot_question(self, bot_id, question):
        # Fixme: 単に取得しているだけで、good/badの数がの多い順に並び替えられていない
        return self._data[(self._data['bot_id'] == bot_id) & (self._data['question'] == question) & (self._data['question_answer_id'] != 0)]
