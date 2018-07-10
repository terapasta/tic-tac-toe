import pandas as pd
from app.shared.constants import Constants
from app.shared.base_cls import BaseCls


class Synonyms(BaseCls):
    def __init__(self):
        self._data = pd.read_csv('./fixtures/synonyms.yml')

    def all(self):
        return self._data

    def by_bot(self, bot_id):
        return self._data[self._data['bot_id'] == bot_id]
