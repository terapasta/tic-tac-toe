# -*- coding: utf-8 -
import logging
import MeCab

class Nlang:
    #UNIDIC_PATH = '/usr/local/lib/mecab/dic/unidic/'

    # def __init__(self, db=None):
    #     if db is None:
    #       return
    #     self.lines = []
    #     self.texts = []
    #     self.category_ids = []
    #     self.splited_texts = []
    #     self.labels = []
    #     self.load_from_tinydb(db)
    #
    # def load_from_tinydb(self, tinydb):
    #     results = tinydb.all()
    #     for record in results:
    #         self.lines.append(record)
    #         self.texts.append(record['text'])
    #         self.category_ids.append(record['category_id'])
    #         self.splited_texts.append(self.split(record['text']))
    #         self.labels.append(record['label'])
    #
    @classmethod
    def split(self, text):
        logging.debug('hogehoge7')
        #print text
        #tagger = MeCab.Tagger("-d " + DataParser.UNIDIC_PATH)
        tagger = MeCab.Tagger("-u learning/dict/custom.dic")
        text = text.encode("utf-8")  # TODO コマンド実行だとエラーになる
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
        logging.debug('hogehoge6')
        splited_texts = []
        for text in texts:
            splited_texts.append(self.split(text))
        return splited_texts
