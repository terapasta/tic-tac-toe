import re
import yaml
import pandas as pd
from app.shared.base_cls import BaseCls


class DocumentGenerator(BaseCls):

    __DICT_FILE_PATH = "fixtures/synonyms.yaml"

    def __init__(self):
        pass

    def generate_by_replacement(self, source):
        dict = self._load_dict()
        return self._expand_dict_to_text(source, dict)

    def _load_dict(self):
        df = None
        with open(self.__DICT_FILE_PATH, 'r') as f:
            df = pd.io.json.json_normalize(yaml.load(f))
        return df

    def _expand_dict_to_text(self, text, dict):
        docs = [text]
        for key in dict.keys():
            if re.match(key, text):
                for replacement in dict[key][0]:
                    docs.append(text.replace(key, replacement))
        return docs
