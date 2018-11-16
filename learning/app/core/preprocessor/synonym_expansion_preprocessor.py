import re
from app.core.preprocessor.base_preprocessor import BasePreprocessor
from app.shared.datasource.datasource import Datasource


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
        #
        # また、zip は iterator を生成するが、
        # iterator は終端まで行くと StopIteration を return するので、
        # 複数回ループを回すことができない
        # これを回避するため、一旦 list に変換する
        words_and_values = list(zip([re.compile(x) for x in synonym_mappings.word], synonym_mappings.value))

        # generator を使うことで省メモリ化と高速化を行う
        return [r for r in self._generate_synonym_expander(texts, words_and_values)]

    def _generate_synonym_expander(self, texts, words_and_values):
        # return しないで yield したほうがオーバーヘッドが小さく、高速かつ省メモリ
        for text in texts:
            res_array = [text]
            for word, value in words_and_values:
                if re.match(word, text):
                    res_array.append(re.sub(word, value, text))

            # あとで tokeinze するので、とりあえず 1つの文字列として繋げておく
            yield ' '.join(res_array)
