import re
from app.core.preprocessor.base_preprocessor import BasePreprocessor
from app.shared.datasource.datasource import Datasource


class WordNormalizationPreprocessor(BasePreprocessor):
    def __init__(self, bot, datasource: Datasource):
        self._bot = bot
        self._synonyms = datasource.synonyms

    def perform(self, texts):
        # ボット固有の辞書を優先して変換する
        # bot_id = N/A のもの（システム辞書）は、リスト順で後ろの方に移動
        # https://www.pivotaltracker.com/n/projects/1879711/stories/162856567
        synonyms = self._synonyms.by_bot(self._bot.id).sort_values('bot_id', na_position='last')
        return self._normalize_word(texts, synonyms)

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
                    # 変換前の文字列に変換後の文字列が含まれる場合、過剰置換してしまうので、
                    # （例えば、プリンタという辞書が登録されており、プリンターという文字列を見るとプリンターーとなってしまう）
                    # 一度変換後の文字列で split して、後に join することで変換しないようにする
                    #
                    normalized = word.join([re.sub(value, word, x) for x in text.split(word)])

                    # N:1 なので、シノニムが一つでも見つかった場合は、これ以降のループは不要
                    if normalized != text:
                        yield normalized

                        found = True
                        break

            # シノニムが存在しない場合は元の文を返す
            if not found:
                yield text
