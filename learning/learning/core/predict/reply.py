import numpy as np
import pandas as pd
import dataset
# import MySQLdb
from learning.log import logger
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.externals import joblib
from ..nlang import Nlang
from .model_not_exists_error import ModelNotExistsError
from learning.config.config import Config
from learning.core.training_set.text_array import TextArray
from learning.core.predict.tag import Tag
from learning.core.persistance import Persistance

class Reply:
    def __init__(self, bot_id, learning_parameter):
        config = Config()
        dbconfig = config.get('database')
        self.db = dataset.connect(dbconfig['endpoint'])
        self.learning_parameter = learning_parameter

        try:
            self.bot_id = bot_id
            self.estimator = Persistance.load_model(bot_id)
            self.vocabulary = Persistance.load_vocabulary(bot_id)
            self.vectorizer = joblib.load("learning/models/%s/%s_vectorizer.pkl" % (config.env, bot_id))
        except IOError:
            raise ModelNotExistsError()

    def predict(self, X):
        # X = [
        #     Nlang.split('セキュリティはどう？'),
        #     Nlang.split('セキュリティはどうなってる？'),
        #     Nlang.split('どんな会社が使ってる？'),
        #     Nlang.split('何歳ですか？'),
        #     Nlang.split('サーバーはどこ使ってるの？'),
        #     Nlang.split('ECサイトでも使えますか？'),
        #     Nlang.split('どんな質問ならいける？'),
        #     Nlang.split('クラウドサービスですか？'),
        # ]
        # X = [
        #     'セキュリティはどう？',
        #     'セキュリティはどうなってる？',
        #     'どんな会社が使ってる？',
        #     '何歳ですか？',
        #     'サーバーはどこ使ってるの？',
        #     'ECサイトでも使えますか？',
        #     'どんな質問ならいける？',
        #     'クラウドサービスですか？',
        # ]

        text_array = TextArray(X, vocabulary=self.vocabulary, vectorizer=self.vectorizer)
        features = text_array.to_vec()

        # if self.learning_parameter.include_tag_vector:
        #     tag = Tag()
        #     tag_vec = tag.predict(Xtrain, return_type='binarized')
        #     features = np.c_[tag_vec, Xtrain_vec]
        #

        # features = text_array.to_vec()
        # vectorizer = training_set.body_array.vectorizer
        # X = text_array.splited_data()
        # features = self.vectorizer.transform(X)
        answers = self.estimator.predict(features)
        probabilities = self.estimator.predict_proba(features)
        max_probability = np.max(probabilities)

        for (question, answer, probabilities2) in zip(X, answers, probabilities):
            print('question: %s' % question)
            print('answer: %s' % answer)
            print('proba: %s \n' % max(probabilities2))

        results_ordered_by_probability = list(map(lambda x: {
            'answer_id': float(x[0]), 'probability': x[1]
        }, sorted(zip(self.estimator.classes_, probabilities[0]), key=lambda x: x[1], reverse=True)))
        #
        # logger.debug('X: %s' % X)
        logger.debug('results_ordered_by_probability: %s' % results_ordered_by_probability)
        # logger.debug('max_probability: %s' % max_probability)

        return results_ordered_by_probability[0:10]

    def __replace_text2vec(self, Xtrain):
        texts = Xtrain[:,-1:].flatten()
        splited_texts = Nlang.batch_split(texts)
        logger.debug('分割後の文字列: %s' % splited_texts)

        # TODO TextArrayクラスで共通化したい
        texts_vec = self.vectorizer.transform(splited_texts)
        texts_vec = texts_vec.toarray()
        logger.debug("texts_vec: %s" % texts_vec)
        # logger.debug("texts_vec: %s" % texts_vec)

        for text in splited_texts[0].split(' '):
            voc = self.vectorizer.get_feature_names()
            if text in voc:
                wid = voc.index(text)
                logger.debug("%s のTF-IDF値: %s" % (text, texts_vec[0][wid]))


    def __out_log(self, answer_id):
        answers_table = self.db['answers']
        answer = answers_table.find_one(id=answer_id)
        logger.debug('予測された回答ID: %s' % answer_id)
        if answer is not None:
            logger.debug('予測された回答: %s' % answer['body'])
