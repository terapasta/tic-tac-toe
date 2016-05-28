# -*- coding: utf-8 -
import MeCab
import numpy as np
from tinydb import TinyDB, Query

class Dataset:
    UNIDIC_PATH = '/usr/local/lib/mecab/dic/unidic/'

    def __init__(self, db_path=None):
        if db_path is None:
          return
        self.question_id1s = []
        self.question_ids = []
        self.texts = []
        self.answer_ids = []
        self.load_from_tinydb(db_path)

    def load_from_tinydb(self, db_path):
        question_id1s = []
        question_ids = []
        texts = []
        splited_texts = []
        answer_ids = []

        db = TinyDB(db_path)
        results = db.all()
        for record in results:
            #self.lines.append(record)
            question_id1s.append(record['question_id1'])
            question_ids.append(record['question_id'])
            texts.append(record['text'])
            splited_texts.append(self.split(record['text']))
            answer_ids.append(record['answer_id'])

        # HACK 最初からnp.arrayを使えばいい
        self.question_id1s = np.array(question_id1s).T
        self.question_ids = np.array(question_ids).T
        self.texts = np.array(texts).T
        self.splited_texts = np.array(splited_texts).T
        self.answer_ids = np.array(answer_ids).T

    def split(self, text):
        #tagger = MeCab.Tagger("-d " + DataParser.UNIDIC_PATH)
        tagger = MeCab.Tagger("-u dict/custom.dic")
        text = text.encode("utf-8")
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
