import re
from app.core.preprocessor.base_preprocessor import BasePreprocessor
from app.shared.datasource.datasource import Datasource
from IPython import embed


class SynonymExpansionPreprocessor(BasePreprocessor):
    def __init__(self, bot, datasource: Datasource):
        self._bot = bot
        self._synonyms = datasource.synonyms

    def perform(self, texts):
        return self._expand_synonyms(texts, self._synonyms.by_bot(self._bot.id))

    def _expand_synonyms(self, texts, synonym_mappings):
        result = []
        for text in texts:
            for r in self._expand_synonyms_to_single_text(text, synonym_mappings):
                result.append(r)
        return result

    def _expand_synonyms_to_single_text(self, text, synonym_mappings):
        expanded = [text]
        for mapping in synonym_mappings.itertuples():
            if re.match(mapping.word, text):
                expanded.append(re.sub(mapping.word, mapping.value, text))
        return expanded
