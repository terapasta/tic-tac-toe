import re
from app.shared.base_cls import BaseCls


class DocumentGenerator(BaseCls):

    def __init__(self):
        pass

    def generate_by_replacement(self, source, dict):
        return self._expand_dict_to_text(source, dict)

    def _expand_dict_to_text(self, text, dict):
        # NOTE:
        # dict は id, word, value, bot_id を持つ pandas.DataFrame型
        #
        docs = [text]
        for tpl in dict.itertuples():
            if re.match(tpl.word, text):
                docs.append(text.replace(tpl.word, tpl.value))
        return docs
