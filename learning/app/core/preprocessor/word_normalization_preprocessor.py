import re
from app.core.preprocessor.base_preprocessor import BasePreprocessor
from app.shared.datasource.datasource import Datasource


class WordNormalizationPreprocessor(BasePreprocessor):
    def __init__(self, bot, datasource: Datasource):
        self._bot = bot
        self._synonyms = datasource.synonyms

    def perform(self, texts):
        return self._normalize_word(texts, self._synonyms.by_bot(self._bot.id))

    def _normalize_word(self, texts, synonym_mappings):
        # DataFrame から itertupples でループを回すよりも、
        # word と value を取得してから zip でまとめてループで回した方が早い
        # word は正規表現にコンパイルしておく
        #
        # また、zip は iterator を生成するが、
        # iterator は終端まで行くと StopIteration を return するので、
        # 複数回ループを回すことができない
        # これを回避するため、一旦 list に変換する
        words_and_values = list(zip(synonym_mappings.word, [re.compile(x) for x in synonym_mappings.value]))

        # generator を使うことで省メモリ化と高速化を行う
        return [r for r in self._generate_word_normalizer(texts, words_and_values)]

    def _generate_word_normalizer(self, texts, words_and_values):
        # return しないで yield したほうがオーバーヘッドが小さく、高速かつ省メモリ
        for text in texts:
            found = False
            for word, value in words_and_values:
                if re.match(value, text):
                    #
                    # シノニムとして登録した語は、元の語に寄せる
                    # https://www.pivotaltracker.com/n/projects/1879711/stories/161807765
                    #
                    yield re.sub(value, word, text)

                    # N:1 なので、シノニムが一つでも見つかった場合は、これ以降のループは不要
                    found = True
                    break

            # シノニムが存在しない場合は元の文を返す
            if not found:
                yield text
