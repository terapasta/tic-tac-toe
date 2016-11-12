import MeCab
import jaconv
from learning.log import logger
from pykakasi import kakasi
from sklearn.externals import joblib

class Nlang:
    #UNIDIC_PATH = '/usr/local/lib/mecab/dic/unidic/'

    @classmethod
    def split(self, text):
        vkakasi = kakasi()
        vkakasi.setMode("J","H")
        conv = vkakasi.getConverter()

        #tagger = MeCab.Tagger("-d " + DataParser.UNIDIC_PATH)
        tagger = MeCab.Tagger("-u learning/dict/custom.dic")
        # text = text.encode('utf-8')
        tagger.parse('')  # node.surfaceを取得出来るようにするため、空文字をparseする(Python3のバグの模様)
        node = tagger.parseToNode(text)
        word_list = []
        while node:
            # logger.debug(node.feature)
            features = node.feature.split(",")
            pos = features[0]
            # if pos in ["名詞", "動詞", "形容詞", "感動詞", "助動詞", "副詞"]:
            if pos in ["名詞", "動詞", "形容詞", "感動詞", "副詞"]:
                if pos == '名詞' and features[1] == '非自立':
                    node = node.next
                    continue
                lemma = node.feature.split(",")[6]  #.decode("utf-8")
                if lemma == 'ある':
                    node = node.next
                    continue

                if lemma == "*":
                    lemma = node.surface  #.decode("utf-8")

                word_list.append(conv.do(jaconv.kata2hira(lemma)))
                # word_list.append(jaconv.kata2hira(lemma))
                # word_list.append(lemma)
            node = node.next
        return " ".join(word_list)

    @classmethod
    def batch_split(self, texts):
        #logging.debug('hogehoge')
        splited_texts = []
        for text in texts:
            splited_texts.append(self.split(text))
        return splited_texts


    # def texts2vec(self, splited_texts, vocabulary_path):
    #     count_vectorizer = CountVectorizer()
    #     print(splited_texts)
    #     feature_vectors = count_vectorizer.fit_transform(splited_texts)
    #     vocabulary = count_vectorizer.get_feature_names()
    #     joblib.dump(vocabulary, vocabulary_path)  # TODO dumpする処理はこのクラスの責務外なのでリファクタリングしたい
    #     return feature_vectors
