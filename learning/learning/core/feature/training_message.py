# -*- coding: utf-8 -
import MeCab
import numpy as np
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.externals import joblib

class TrainingMessage:

    def __init__(self, db):
        #self.trainings = db['trainings'].all()
        self.training_messages = db['training_messages'].find(order_by='training_id, id')

    # TODO numpyのarrayを使う
    #
    # DBのテーブルを検索した結果をfeatureとして使える形式に整形する
    #
    # +----+-------------+-----------+---------+--------------------------------------------------+
    # | id | training_id | answer_id | speaker | body                                             |
    # +----+-------------+-----------+---------+--------------------------------------------------+
    # |  1 |           1 |      NULL | guest   | おーい                                           |
    # |  2 |           1 |         2 | bot     | はーい。なんですか？                             |
    # |  3 |           1 |      NULL | guest   | 最近調子はどう？                                 |
    # |  4 |           1 |         3 | bot     | ぼちぼちでんな                                   |
    # |  5 |           1 |      NULL | guest   | 儲かってるってこと？                             |
    # |  6 |           1 |         4 | bot     | まあそれもぼちぼちってこっちゃ。                 |
    # |  7 |           1 |      NULL | guest   | じゃあきっといいもの食べてるね？                 |
    # |  8 |           1 |         5 | bot     | まあね。カニとか食べるよ                         |
    # +----+-------------+-----------+---------+--------------------------------------------------+
    #
    # => 下記のようなデータに整形する
    #
    # [[0, 0, 0, 0, 'おーい', 2],
    # [0, 0, 0, 2, '最近調子はどう？', 3],
    # [0, 0, 2, 3, '儲かってるってこと？', 4],
    # [0, 2, 3, 4, 'じゃあきっといいもの食べてるよね？', 5]]
    def build(self):
        trainings = self.__partition_each_training(self.training_messages)
        training_sets = []

        for tmp_training_set in trainings:
            tmp_training_set.insert(0, dict(answer_id=0, body=''))
            tmp_training_set.insert(0, dict(answer_id=0, body=''))
            tmp_training_set.insert(0, dict(answer_id=0, body=''))

            answer_id_indexs = self.__lookup_anser_indexs(tmp_training_set)

            for answer_id_index in answer_id_indexs:
                training_set = []
                for training_message in tmp_training_set[answer_id_index:]:
                    if len(training_set) < 4:
                        if training_message['answer_id'] is not None:
                            training_set.append(training_message['answer_id'])
                    elif len(training_set) == 4:
                        training_set.append(training_message['body'])
                    elif len(training_set) == 5:
                        training_set.append(training_message['answer_id'])

                if len(training_set) >= 6:
                    training_sets.append(training_set)

        bodies = self.__extract_bodies(training_sets)
        bodies = self.__split_bodies(bodies)
        bodies_vec = self.__texts2vec(bodies)
        feature = self.__combine(training_sets, bodies_vec)
        return feature

    # trainingごとのtraining_messageに分ける
    def __partition_each_training(self, training_messages):
        trainings = []
        tmp_training_messages = []
        pre_training_id = None

        for training_message in self.training_messages:
            if pre_training_id == training_message['training_id']:
                tmp_traning_messages.append(training_message)
            else:
                trainings.append(tmp_traning_messages)
                tmp_training_messages = []
                pre_training_id = training_message['training_id']

    def __lookup_anser_indexs(self, training_messages):
        answer_id_indexs = []
        for index, training_message in enumerate(training_messages):
            if training_message['answer_id'] is not None:
                answer_id_indexs.append(index)
        return answer_id_indexs

    def __extract_bodies(self, training_sets):
        bodies = []
        for training_set in training_sets:
            bodies.append(training_set[-2])

        return bodies

    def __split_bodies(self, bodies):
        splited_bodies = []
        for body in bodies:
            splited_bodies.append(self.split(body))
        return splited_bodies

    # TODO 共通化しておく
    def __texts2vec(self, splited_texts):
        count_vectorizer = CountVectorizer()
        feature_vectors = count_vectorizer.fit_transform(splited_texts)
        vocabulary = count_vectorizer.get_feature_names()  # TODO vocabularyは保存する必要がある
        joblib.dump(vocabulary, 'learning/vocabulary/vocabulary.pkl')
        return feature_vectors

    def __combine(self, training_sets, bodies_vec):
        tmp_training_sets = np.array(training_sets)
        #labels = tmp_training_sets
        #tmp_bodies_vec = np.array(bodies_vec)
        #tmp_training_sets = np.delete(tmp_training_sets, -2, 1)
        #feature = np.c_[tmp_training_sets[:,:-2], tmp_bodies_vec, tmp_training_sets[:,-1:]]
        feature = np.c_[tmp_training_sets[:,:-2], bodies_vec.toarray(), tmp_training_sets[:,-1:]]
        return feature

    # TODO 共通化しておく
    def split(self, text):
        #tagger = MeCab.Tagger("-d " + DataParser.UNIDIC_PATH)
        #tagger = MeCab.Tagger("-u dict/custom.dic")
        tagger = MeCab.Tagger()  # TODO customを使いたい
        #text = text.encode("utf-8")
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
