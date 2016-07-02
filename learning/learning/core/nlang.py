# -*- coding: utf-8 -
import MeCab
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.externals import joblib

class Nlang:
    #UNIDIC_PATH = '/usr/local/lib/mecab/dic/unidic/'

    @classmethod
    def split(self, text):
        #print text
        #tagger = MeCab.Tagger("-d " + DataParser.UNIDIC_PATH)
        tagger = MeCab.Tagger("-u learning/dict/custom.dic")
        #text = text.encode("utf-8")  # TODO コマンド実行だとエラーになる
        node = tagger.parseToNode(text)
        word_list = []
        while node:
            pos = node.feature.split(",")[0]
            if pos in ["名詞", "動詞", "形容詞", "感動詞", "助動詞"]:
                lemma = node.feature.split(",")[6].decode("utf-8")
                if lemma == u"*":
                    lemma = node.surface.decode("utf-8")
                word_list.append(lemma)
            node = node.next
        return u" ".join(word_list)

    @classmethod
    def batch_split(self, texts):
        logging.debug('hogehoge')
        splited_texts = []
        for text in texts:
            splited_texts.append(self.split(text))
        return splited_texts

    @classmethod
    def texts2vec(self, splited_texts, vocabulary_path):
        count_vectorizer = CountVectorizer()
        print splited_texts
        feature_vectors = count_vectorizer.fit_transform(splited_texts)
        vocabulary = count_vectorizer.get_feature_names()
        #joblib.dump(vocabulary, 'learning/vocabulary/vocabulary.pkl')
        joblib.dump(vocabulary, vocabulary_path)
        return feature_vectors
