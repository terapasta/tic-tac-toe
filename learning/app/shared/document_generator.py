import re
from app.shared.base_cls import BaseCls


class DocumentGenerator(BaseCls):

    def __init__(self):
        pass

    def generate_by_replacement(self, source, dict):
        return self._expand_dict_to_text(source, dict)

    def _expand_dict_to_text(self, text, dict):
        docs = [text]
        for key in dict.keys():
            if re.match(key, text):
                for replacement in dict[key][0]:
                    docs.append(text.replace(key, replacement))
        return docs
