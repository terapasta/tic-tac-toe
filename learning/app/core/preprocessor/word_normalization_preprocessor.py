import re
import MeCab
import pandas as pd

from functools import reduce
from app.core.preprocessor.base_preprocessor import BasePreprocessor
from app.shared.datasource.datasource import Datasource


class WordNormalizationPreprocessor(BasePreprocessor):
    def __init__(self, bot, datasource: Datasource):
        self._bot = bot
        self._synonyms = datasource.synonyms
        self._tagger = MeCab.Tagger("-Owakati")

    def perform(self, texts):
        # 対象の文章を一旦 tokenize する
        # https://www.pivotaltracker.com/n/projects/1879711/stories/164325275
        texts = [self._tokenize(x) for x in texts]

        # ボット固有の辞書を優先して変換する
        # bot_id = N/A のもの（システム辞書）は、リスト順で後ろの方に移動
        # https://www.pivotaltracker.com/n/projects/1879711/stories/162856567
        synonyms = self._synonyms.by_bot(self._bot.id).sort_values('bot_id', na_position='last')

        # 変換が循環していると、システム辞書とユーザー辞書の関係で変換が異なる場合がある
        # https://www.pivotaltracker.com/n/projects/1879711/stories/164102017
        synonyms = self.remove_cycle_from_synonyms(synonyms)

        # シノニムも一度 tokenize
        # https://www.pivotaltracker.com/n/projects/1879711/stories/164325275
        synonyms['word'] = synonyms.word.apply(self._tokenize)
        synonyms['value'] = synonyms.value.apply(self._tokenize)

        return [self._trim_whitespaces(x) for x in self._normalize_word(texts, synonyms)]

    def remove_cycle_from_synonyms(self, synonyms):
        ancestors = {}
        for _, row in synonyms.iterrows():
            # value => word の変換が行われる
            # value を親（parent）、wordを子（child）と呼ぶ
            parent  = row['value']
            child = row['word']
            if child not in ancestors:
                ancestors[child] = []

            # 親の祖先を子の祖先にマージ
            inherit = getattr(ancestors, parent, [])
            ancestors[child] = self._merge_lists(ancestors[child], inherit.copy())

            # 親に祖先がいない場合は無条件に子の祖先として親を追加
            if parent not in ancestors:
                ancestors[child] = self._merge_lists(ancestors[child], [parent])
                continue

            # 親の祖先に子が含まれている場合、
            # 子の祖先に親を追加してしまうとサイクルが生じてしまうので、
            # そのような辺を追加しない
            #
            # 可読性は悪いが処理速度を担保するために reduce, lambda, リスト内包表記を使用
            #
            # [x == child for x in ...] で、リスト中の対象の単語が True、そうでない単語が False で置き換えられる
            # 例）[True, False, False]
            #
            # この True/False のリストに対して、1つでも要素が True なら True を返す処理を lambda式で書く
            # 例）[True, False] => True
            #    [False, Fasle] => False
            #
            has_ancestor = reduce(lambda a, b: a or b, [x == child for x in ancestors[parent]], False)
            if not has_ancestor:
                # 親を祖先として追加
                ancestors[child].append(parent)

        # 全ての祖先を子に変換する
        replacements = []
        for word in ancestors.keys():
            for value in ancestors[word]:
                replacements.append({
                    'word': word,
                    'value': value,
                })

        return pd.DataFrame(replacements)

    def _tokenize(self, text):
        #
        # NOTE:
        # 先頭にスペースを入れる
        #
        # 'アイドル ' と 'ドル ' では一致してしまうが、
        # ' アイドル ' と ' ドル ' とは一致しないので、
        # 本来不可分な単語中の部分文字列が置換されるのを防ぐ
        #
        return ' ' + self._tagger.parse(text).replace("\n", "")

    def _trim_whitespaces(self, text):
        return ''.join(text.split(' '))

    def _merge_lists(self, *args):
        add = lambda a, b: a + b
        return self._unique_list(reduce(add, args))

    def _unique_list(self, array):
        return list(set(array))

    def _normalize_word(self, texts, synonym_mappings):
        # DataFrame から itertupples でループを回すよりも、
        # word と value を取得してから zip でまとめてループで回した方が早い
        # word は正規表現にコンパイルしておく
        #
        # また、zip は iterator を生成するが、
        # iterator は終端まで行くと StopIteration を return するので、
        # 複数回ループを回すことができない
        # これを回避するため、一旦 list に変換する
        words_and_values = list(zip(synonym_mappings.word, synonym_mappings.value))

        # generator を使うことで省メモリ化と高速化を行う
        return [r for r in self._generate_word_normalizer(texts, words_and_values)]

    def _generate_word_normalizer(self, texts, words_and_values):
        # return しないで yield したほうがオーバーヘッドが小さく、高速かつ省メモリ
        for text in texts:
            # 一文の中に複数回辞書登録された語が登場する場合があるので、
            # 一つ見つかっても変換を繰り返す
            # https://www.pivotaltracker.com/n/projects/1879711/stories/164266051
            normalized = text

            normalized = reduce(self._replace_word_if_needed, words_and_values, normalized)

            yield normalized

    def _replace_word_if_needed(self, text, word_and_value):
        word, value = word_and_value

        # 変換前の文字列に変換後の文字列が含まれる場合、過剰置換してしまうので、
        # （例えば、プリンタという辞書が登録されており、プリンターという文字列を見るとプリンターーとなってしまう）
        # 一度変換後の文字列で split して、後に join することで変換しないようにする
        #
        if value in word:
            return word.join([x.replace(value, word) for x in text.split(word)])

        #
        # シノニムとして登録した語は、元の語に寄せる
        # https://www.pivotaltracker.com/n/projects/1879711/stories/161807765
        #
        # re.match() だと前方一致のものしか当たらないので、
        # 部分文字列にヒットさせるため re.search() を使う
        # https://www.pivotaltracker.com/n/projects/1879711/stories/163612399
        elif value in text:
            return text.replace(value, word)

        return text
