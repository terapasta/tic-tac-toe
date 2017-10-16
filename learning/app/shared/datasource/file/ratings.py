import pandas as pd


class Ratings:
    def __init__(self):
        self._data = pd.read_csv('./fixtures/ratings.csv')

    def all(self):
        return self._data

    def by_bot(self, bot_id):
        return self._data[self._data['bot_id'] == bot_id]
