import MeCab
import mojimoji

from learning.log import logger


class Nlang:
    #UNIDIC_PATH = '/usr/local/lib/mecab/dic/unidic/'

    @classmethod
    def split(self, text):
        #tagger = MeCab.Tagger("-d " + DataParser.UNIDIC_PATH)
        tagger = MeCab.Tagger("-u learning/dict/custom.dic")
        tagger.parse('')  # node.surfaceを取得出来るようにするため、空文字をparseする(Python3のバグの模様)
        node = tagger.parseToNode(text)
        word_list = []
        while node:
            features = node.feature.split(",")
            pos = features[0]
            # logger.debug("node.feature: %s" % node.feature)

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
                    lemma = node.surface  #.decode("utf-8")

                word_list.append(mojimoji.han_to_zen(lemma))
            node = node.next
        return " ".join(word_list)

    @classmethod
    def batch_split(self, texts):
        splited_texts = []
        for text in texts:
            splited_texts.append(self.split(text))
        return splited_texts


