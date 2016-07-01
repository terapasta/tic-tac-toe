# -*- coding: utf-8 -
# import MeCab
# import sqlite3
# from tinydb import TinyDB, Query
#
class TrainingMessage:

    def __init__(self, db):
        #self.trainings = db['trainings'].all()
        self.training_messages = db['training_messages'].find(order_by='training_id, id')

    # TODO どういうデータを作成したいのかコメント入れる
    # TODO メソッドに分割する
    # TODO numpyのarrayを使う
    def build(self):
        # trainingごとのtraining_messageに分ける
        tmp_training_sets = []
        tmp_training_set = []
        pre_training_id = None

        for training_message in self.training_messages:
            if pre_training_id == training_message['training_id']:
                tmp_training_set.append(training_message)

            else:
                tmp_training_sets.append(tmp_training_set)
                tmp_training_set = []
                pre_training_id = training_message['training_id']

        #print tmp_training_sets

        # answerのindexの配列を取得する
        #tmp_training_sets[2].insert(0, dict(answer_id=0, body=''))
        # answer_id_indexs = []
        # for index, training_message in enumerate(tmp_training_sets[2]):
        #     if training_message['answer_id'] is not None:
        #         answer_id_indexs.append(index)
        #
        # print answer_id_indexs

        training_sets = []

        for tmp_training_set in tmp_training_sets:
            tmp_training_set.insert(0, dict(answer_id=0, body=''))
            tmp_training_set.insert(0, dict(answer_id=0, body=''))
            tmp_training_set.insert(0, dict(answer_id=0, body=''))

            answer_id_indexs = []
            for index, training_message in enumerate(tmp_training_set):
                if training_message['answer_id'] is not None:
                    answer_id_indexs.append(index)

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

        print training_sets
        return training_sets

    # TODO 共通化しておく
    def __texts2vec(self, texts):
        count_vectorizer = CountVectorizer()
        feature_vectors = count_vectorizer.fit_transform(self.dataset.splited_texts)  # TODO
        self.vocabulary = count_vectorizer.get_feature_names()

        #pdb.set_trace()
        features_array = feature_vectors.toarray()
        features = np.c_[self.dataset.answer_id2s, features_array]
        features = np.c_[self.dataset.answer_id1s, features]
        return features


            # for training_message in training['training_messages']:
            #     print training_message.body

#         for record in results:
#             self.lines.append(record)
#             self.texts.append(record['text'])
#             self.category_ids.append(record['category_id'])
#             self.splited_texts.append(self.split(record['text']))
#             self.labels.append(record['label'])
#
#     def split(self, text):
#         #tagger = MeCab.Tagger("-d " + DataParser.UNIDIC_PATH)
#         tagger = MeCab.Tagger("-u dict/custom.dic")
#         text = text.encode("utf-8")
#         node = tagger.parseToNode(text)
#         word_list = []
#         while node:
#             pos = node.feature.split(",")[0]
#             if pos in ["名詞", "動詞", "形容詞", "感動詞", "助動詞"]:
#                 lemma = node.feature.split(",")[6].decode("utf-8")
#                 if lemma == u"*":
#                     lemma = node.surface.decode("utf-8")
#                 word_list.append(lemma)
#             node = node.next
#         return u" ".join(word_list)
