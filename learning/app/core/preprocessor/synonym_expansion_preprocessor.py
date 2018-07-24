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
        # DataFrame から itertupples でループを回すよりも、
        # word と value を取得してから zip でまとめてループで回した方が早い
        # word は正規表現にコンパイルしておく
        words_and_values = zip([re.compile(x) for x in synonym_mappings.word], synonym_mappings.value)

        results = []
        for text in texts:
            results.extend(self._expand_synonyms_to_single_text(text, words_and_values))
        return results

    def _expand_synonyms_to_single_text(self, text, words_and_values):
        # シノニム展開前のテキスト
        results = [text]

        for word, value in words_and_values:
            if re.match(word, text):
                # シノニム展開後のテキスト
                results.append(re.sub(word, value, text))

        return results