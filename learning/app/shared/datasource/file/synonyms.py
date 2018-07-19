import yaml
import pandas as pd
from app.shared.constants import Constants
from app.shared.base_cls import BaseCls


class Synonyms(BaseCls):
    def __init__(self):
        with open('./fixtures/synonyms.yml', 'r') as f:
            self._data = pd.io.json.json_normalize(yaml.load(f))

    def all(self):
        return self._data

    def by_bot(self, bot_id):
        return self._data[self._data['bot_id'] == bot_id]
