# -*- coding: utf-8 -
import logging
import pdb
import numpy as np
import pandas as pd
import MeCab
from sklearn.feature_extraction.text import CountVectorizer

class Predicter:
    UNIDIC_PATH = '/usr/local/lib/mecab/dic/unidic/'

    def __init__(self, estimator, vocabulary):
        self.estimator = estimator
        self.vocabulary = vocabulary

    def predict(self, X):
        logging.basicConfig(filename="example.log",level=logging.DEBUG)

        #logging.debug(X)
        Xtrain = pd.Series(X)
        input_texts = []

        #logging.debug('1')
        #logging.debug(Xtrain)

        for input_text in Xtrain:
            logging.debug(input_text)
            #input_texts.append(self.split(input_text[2].decode('utf-8')))
            input_texts.append(self.split(input_text[2]))

        logging.debug(input_texts)
        #print input_texts

        logging.debug(1)
        count_vectorizer = CountVectorizer(
            vocabulary=self.vocabulary # 学習時の vocabulary を指定する
        )
        logging.debug(2)

        feature_vectors = count_vectorizer.fit_transform(input_texts)
        logging.debug(3)

        # TODO DRYにしたい
        # featureにcategory_idを追加
        features_array = feature_vectors.toarray()
        answer_id1s = np.array(X)[:, 0].T
        answer_id2s = np.array(X)[:, 1].T
        logging.debug(4)
        features_array = np.c_[answer_id2s, features_array]
        features_array = np.c_[answer_id1s, features_array]
        logging.debug(5)
        return self.estimator.predict(features_array)

    # TODO dataset.pyと重複しているメソッド
    def split(self, text):
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
