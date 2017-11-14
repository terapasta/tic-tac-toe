import MeCab
import mojimoji
from app.shared.config import Config
from app.shared.logger import logger
from app.core.tokenizer.base_tokenizer import BaseTokenizer


class MecabTokenizerWithSplit(BaseTokenizer):
    def __init__(self):
        logger.debug('dicdir: ' + Config().get('dicdir'))
        self.tagger = MeCab.Tagger("-u dict/custom.dic -d " + Config().get('dicdir'))
        # Note: node.surfaceを取得出来るようにするため、空文字をparseする(Python3のバグの模様)
        self.tagger.parse('')

    def init(self):
        return self

    def init_by_bot(self, bot):
        return self

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
            pos = features[0]

            if pos in ["名詞", "動詞", "形容詞", "感動詞", "助動詞", "副詞"]:
                lemma = node.feature.split(",")[6]

                if pos == '名詞' and features[1] == '非自立':
                    node = node.next
                    continue
                if pos == '動詞' and features[1] == '非自立':
                    node = node.next
                    continue

                if pos == '助動詞' and lemma != 'ない':
                    node = node.next
                    continue

                if lemma == 'ある':
                    node = node.next
                    continue

                if lemma == "*":
                    lemma = node.surface

                word_list.append(mojimoji.han_to_zen(lemma))
            node = node.next
        return word_list

    def __extract_pos_count(self, target_pos, text):
        node = self.tagger.parseToNode(text)
        count = 0
        while node:
            pos = node.feature.split(',')[0]
            if pos == target_pos:
                count += 1
            node = node.next
        return count
