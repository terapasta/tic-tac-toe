import MeCab
import mojimoji

# TODO:
# パフォーマンス比較をちゃんとする
# c.f., https://qiita.com/yukinoi/items/42f8b5461dc1b62db7f9
import jaconv

from app.shared.config import Config
from app.shared.logger import logger
from app.core.tokenizer.base_tokenizer import BaseTokenizer
from app.shared.part_of_speechs import PartOfSpeech


class FuzzyTermTokenizer(BaseTokenizer):
    def __init__(self):
        logger.debug('dicdir: ' + Config().get('dicdir'))
        self.tagger = MeCab.Tagger("-u dict/custom.dic -d " + Config().get('dicdir'))
        # Note: node.surfaceを取得出来るようにするため、空文字をparseする(Python3のバグの模様)
        self.tagger.parse('')

    def tokenize(self, texts):
        splited_texts = []
        for text in texts:
            splited_texts.append(self._tokenize_single_text(text))
        return splited_texts

    def extract_noun_count(self, text):
        return self.__extract_pos_count('名詞', text)

    def extract_verb_count(self, text):
        return self.__extract_pos_count('動詞', text)

    def _tokenize_single_text(self, text):
        node = self.tagger.parseToNode(text)
        word_list = []
        while node:
            features = node.feature.split(',')
            pos_nl = features[0]

            # 自然言語から enum のキーに変換
            pos = PartOfSpeech.from_word(pos_nl)

            if pos in PartOfSpeech:
                lemma = features[6]

                # 固有名詞などで読みが入らないことがある
                phonetic = None
                if len(features) >= 8:
                    phonetic = features[7]

                if pos == PartOfSpeech.NOUN and features[1] == '非自立':
                    node = node.next
                    continue
                if pos == PartOfSpeech.VERB and features[1] == '非自立':
                    node = node.next
                    continue

                if pos == PartOfSpeech.AUXILIARY_VERB and lemma != 'ない':
                    node = node.next
                    continue

                if lemma == 'ある':
                    node = node.next
                    continue

                if lemma == "*":
                    lemma = node.surface

                # 形態素と読みを併せて返す
                word_list.append(self._normalize_word(lemma))
                if not phonetic is None:
                    word_list.append(self._normalize_word(phonetic))

            node = node.next

        # 'パスワード'などの文字は読みも同じなので、重複を消す
        word_list = self._unique_list(word_list)

        # スペース区切りの文章を返す
        return ' '.join(word_list)

    def __extract_pos_count(self, target_pos, text):
        node = self.tagger.parseToNode(text)
        count = 0
        while node:
            pos = node.feature.split(',')[0]
            if pos == target_pos:
                count += 1
            node = node.next
        return count

    def _unique_list(self, dup_list):
        # NOTE:
        # 一度 set に変換すると重複が排除される
        return list(set(dup_list))

    def _normalize_word(self, word):
        return mojimoji.han_to_zen( # 半角 -> 全角
                 jaconv.kata2hira(  # カタカナ -> ひらがな
                   word.lower()   # 大文字 -> 小文字
                 )
               )