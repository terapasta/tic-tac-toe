import MeCab
import mojimoji


class MecabTokenizer:
    def __init__(self):
        self.tagger = MeCab.Tagger("-u dict/custom.dic")
        # Note: node.surfaceを取得出来るようにするため、空文字をparseする(Python3のバグの模様)
        self.tagger.parse('')

    def tokenize(self, texts):
        splited_texts = []
        for text in texts:
            splited_texts.append(self.tokenize_single_text(text))
        return splited_texts

    def extract_noun_count(self, text):
        node = self.tagger.parseToNode(text)
        noun_count = 0
        while node:
            pos = node.feature.split(',')[0]
            if pos == '名詞':
                noun_count += 1
            node = node.next
        return noun_count

    def tokenize_single_text(self, text):
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
        return " ".join(word_list)
