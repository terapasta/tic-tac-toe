# -*- coding: utf-8 -*-

from scipy.sparse import csr_matrix
import numpy as np

def bincount(x, weights=None, minlength=None):
    if len(x) > 0:
        return np.bincount(x, weights, minlength)
    else:
        if minlength is None:
            minlength = 0
        minlength = np.asscalar(np.asarray(minlength, dtype=np.intp))
        return np.zeros(minlength, dtype=np.intp)

def count_sample_by_label(labels):
    '''
        ラベルごとのサンプル数を調査
    '''
    y = np.asarray(labels)
    n_samples = y.shape[0]

    unique_labels, y_inversed = np.unique(y, return_inverse=True)
    label_counts = bincount(y_inversed)

    sample_count = []
    for i, unique_label in enumerate(unique_labels):
        sample_count.append([unique_label, label_counts[i]])

    return sample_count


import shutil
import os

def copy_testdata_csv(learning_dir, csv_file_name):
    '''
        データファイルは、既存の訓練データを別場所にコピーしてから使用します
        テストデータは、csv_file_name で指定したものを使用します。

        usage:
            csv_file_name = 'test_benefitone_conversation.csv'
            copied_csv_file_path = copy_testdata_csv(learning_dir, csv_file_name)

    '''
    if type(csv_file_name) == list:
        copied_csv_file_paths = []
        for f in csv_file_name:
            n = copy_testdata_csv(learning_dir, f)
            copied_csv_file_paths.append(n)

        return copied_csv_file_paths

    original_csv_dir = os.path.join(learning_dir, 'learning/tests/fixtures/')
    original_file_path = os.path.join(original_csv_dir, csv_file_name)

    prototype_dir = os.path.join(learning_dir, 'prototype')
    csv_dir = os.path.join(prototype_dir, 'resources')

    shutil.copy2(original_file_path, csv_dir)
    copied_csv_file_path = os.path.join(csv_dir, csv_file_name)
    print('CSV file for test=[%s]' % copied_csv_file_path)

    return copied_csv_file_path


'''
    feature をダンプするためのツール
'''
def get_item_from_vocabulary(vocabulary, index):
    '''
        vocabulary から指定インデックスの単語を参照
    '''
    for k, v in vocabulary.items():
        if v == index:
            return k

    return None

def dump_features(arr, vocabulary):
    features_str = ''

    for i, v in enumerate(arr):
        if v == 0.0:
            continue

        if features_str != '':
            features_str += ' '
        
        item = get_item_from_vocabulary(vocabulary, i)
        features_str += '%s=%0.3f' % (item, v)

    return '[' + features_str + ']'

def get_dumped_features(X_error, vocabulary):
    dumped_features = []

    for i, label in enumerate(X_error):
        arr = X_error[i].toarray()[0]
        dump_str = dump_features(arr, vocabulary)
        dumped_features.append('index=%d%s' % (i, dump_str))

    return dumped_features

'''
    データ性質を分析するためのツール
'''
from learning.core.learn.learning_parameter import LearningParameter
from learning.core.training_set.training_message_from_csv import TrainingMessageFromCsv

def get_num_of_feature_and_class(csv_file_path):
    '''
        訓練データの feature数／class数を
        カウントして表示します
    '''

    '''
        初期設定
        データファイル、エンコードを指定
        内容は、learn.py を参考にしました。    
    '''
    attr = {
        'include_failed_data': False,
        'include_tag_vector': False,
        'classify_threshold': None,
        'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION,
        'params_for_algorithm': {}
    }
    learning_parameter = LearningParameter(attr)
    bot_id = 7777
    csv_file_encoding = 'utf-8'
    
    '''
    訓練データの生成（内部で TF-IDF 処理を実行）
    '''
    training_set = TrainingMessageFromCsv(bot_id, csv_file_path, learning_parameter, encoding=csv_file_encoding)
    build_training_set_from_csv = training_set.build()

    X = build_training_set_from_csv.x
    y = build_training_set_from_csv.y
    
    '''
        サンプル数、feature数を求める
    '''
    n_sample = X.shape[0]
    n_feature = X.shape[1]
    
    '''
        クラス数を求める
    '''
    classes = {}
    for c in y:
        if c not in classes.keys():
            classes[c] = 1
        else:
            classes[c] += 1

    dump_string = "[%s] sample=%d, feature=%d, class=%d" % (
        os.path.basename(csv_file_path), 
        n_sample, 
        n_feature,
        len(classes.items())
    )
    return dump_string


'''
    テストデータ生成ツール
'''
from learning.core.training_set.text_array import TextArray

def prepare_tf_idf_vectors(csv_file_path):
    '''
        初期設定
        内容は、learn.py を参考にしました。    
    '''
    attr = {
        'include_failed_data': False,
        'include_tag_vector': False,
        'classify_threshold': None,
        # 'algorithm': LearningParameter.ALGORITHM_NAIVE_BAYES
        'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION,
        # 'params_for_algorithm': { 'C': 200 }
        'params_for_algorithm': {}
    }
    learning_parameter = LearningParameter(attr)

    '''
        訓練データの生成（内部で TF-IDF 処理を実行）
    '''
    bot_id = 7777
    training_set = TrainingMessageFromCsv(bot_id, csv_file_path, learning_parameter, encoding='utf-8')

    build_training_set_from_csv = training_set.build()
    X = build_training_set_from_csv.x
    y = build_training_set_from_csv.y

    '''
        ベクトライザーは予測時に使用します
    '''
    vectorizer = training_set.body_array.vectorizer
    
    return (X, y, vectorizer)

def prepare_tf_idf_vectors_from_questions(questions, vectorizer):
    '''
        学習時に生成されたTF-IDFベクトライザーを使用して
        未知の質問データのTF-IDFベクターを取得
    '''
    text_array = TextArray(questions, vectorizer=vectorizer)

    return text_array.to_vec()


''' 
    Accuracy を算出するツール
'''
def accuracy_score(y, y_pred, y_probas):
    ''' 
        実績のあるプロダクション・コードから、
        そのまま拝借しています
    ''' 
    # 予測結果と実際を比較
    bools = y == y_pred

    # しきい値を超えているもののみをTrueにする
    y_proba = np.max(y_probas, axis=1)
    bools = bools == (y_proba > 0.5)

    # 正当率を算出
    score = np.sum(bools) / np.size(bools, axis=0)

    return score