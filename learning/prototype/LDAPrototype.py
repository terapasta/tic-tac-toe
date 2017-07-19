# -*- coding: utf-8 -*-
import os
from sklearn.decomposition import LatentDirichletAllocation

class LDA():
    def __str__(self):
        return 'This class is prototype of sklearn.decomposition.LatentDirichletAllocation'

    def __init__(self):
        self.lda = None
        self.n_topics = 10      # トピック分類件数
        self.n_iter   = 20      # 繰り返し実行回数
        self.n_offset = 25.0    # （意味を調査中）
        self.random_state = 1   # （意味を調査中）

    def init_lda_model(self):
        self.lda = LatentDirichletAllocation(
                        n_topics=self.n_topics,
                        max_iter=self.n_iter,
                        learning_method='online',
                        learning_offset=self.n_offset,
                        random_state=self.random_state)

    def initial_fit_and_transform(self, tf):
        self.lda.fit(tf)
        return self.lda.transform(tf)

    def partial_fit_and_transform(self, tf):
        self.lda.partial_fit(tf)
        return self.lda.transform(tf)

    def get_top_features_in_topic(self, n_top_features):
        ''' トピックに含まれる上位の特徴語インデックスの配列を戻します。
            何位まで取得するかを n_top_features で指定します。
        '''
        top_features = []
        for topic_idx, topic in enumerate(self.lda.components_):
            # 特徴語インデックスを、単語出現確率の高いもの順に取得
            top_features_idx_list = topic.argsort()
            reverse_idx = -n_top_features - 1
            sorted_list = top_features_idx_list[:reverse_idx:-1]
    
            # 取得した特徴語インデックスを、リストに格納
            top_features.append(sorted_list)
    
        # 完成したリストを戻す
        return top_features

    def get_hit_topic_idx(self, probs):
        ''' 学習結果の配列 probs から、予測されたトピックのインデックスを戻します。
            probs = initial_fit_and_transform, partial_fit_and_transform の戻り値配列
            
        '''
        topic_idx = 0
        max_prob = 0.0
        for i in range(0, len(probs)):
            if max_prob < probs[i]:
                topic_idx = i
                max_prob = probs[i]

        return topic_idx


class LDATestDataGenerator():
    def __init__(self):
        self.corpus = []
        self.origin_text = []
        self.tf_vector = None
        self.tf_feature_names = None

    def replace_newline(self, val):
        return val.replace('\r', '').replace('\n', '')

    def generate_testdata(self):
        import pandas

        n_samples = 100

        csvDir = "../learning/tests/engine/fixtures/"
        csvFile = "test_daikin_conversation.csv"
        csvPath = os.path.join(csvDir, csvFile)

        csvTemp = pandas.read_csv(csvPath, encoding='Shift_JIS')
        csvData = csvTemp.drop_duplicates(subset=['answer_id'])

        testData = csvData.ix[0:n_samples-1, ['question', 'answer_body']]

        import MeCab
        meCab = MeCab.Tagger('-Owakati -d /usr/local/lib/mecab/dic/ipadic')

        for i in range(0, n_samples):
            try:
                question = testData.ix[i, 'question']
            except:
                continue
            question = self.replace_newline(question)
            parsed_text = meCab.parse(question)
            self.corpus.append(self.replace_newline(parsed_text))
            self.origin_text.append(self.replace_newline(question))

        n_samples = len(self.corpus)
        print('Parsed questions (count=%d):' % n_samples)

    def generate_tf_vector_and_feature(self):
        from sklearn.feature_extraction.text import CountVectorizer

        n_features = 1000
        tf_vectorizer = CountVectorizer(max_df=0.66,
                                        min_df=1,
                                        max_features=n_features # 特徴語の上限
                                        )

        self.tf_vector = tf_vectorizer.fit_transform(self.corpus)
        self.tf_feature_names = tf_vectorizer.get_feature_names()

    def print_top_words_in_topic(lda, top_words_list, n_top_words):
        top_words_list = get_top_words_in_topic(lda, tf_feature_names, n_top_words)
        for topic_idx, top_words in enumerate(top_words_list):
            print("Topic #%d:" % topic_idx)
            print(",".join(top_words))

