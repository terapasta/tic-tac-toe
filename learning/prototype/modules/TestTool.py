# -*- coding: utf-8 -*-

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
    original_csv_dir = os.path.join(learning_dir, 'learning/tests/engine/fixtures/')
    original_file_path = os.path.join(original_csv_dir, csv_file_name)

    prototype_dir = os.path.join(learning_dir, 'prototype')
    csv_dir = os.path.join(prototype_dir, 'resources')

    shutil.copy2(original_file_path, csv_dir)
    copied_csv_file_path = os.path.join(csv_dir, csv_file_name)
    print('CSV file for test=[%s]' % copied_csv_file_path)

    return copied_csv_file_path
    