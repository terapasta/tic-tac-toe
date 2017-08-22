from unittest import TestCase
from nose.tools import ok_, eq_

import MySQLdb
import glob
import numpy as np
import pandas as pd

from learning.config.config import Config
from learning.core.datasource import Datasource

class DatasourceTestCase(TestCase):
    bot_id = 8  # bot_id = 8 はPTNA
    csv_dir_name = './fixtures/learning_training_messages/'
    csv_file_name = 'ptna.csv'

    @classmethod
    def setUpClass(cls):
        config = Config()
        dbconfig = config.get('database')
        cls.db = MySQLdb.connect(host=dbconfig['host'], db=dbconfig['name'], user=dbconfig['user'],
                             passwd=dbconfig['password'], charset='utf8')

    def test_all_learning_training_messages_from_database(self):
        # テーブルの該当レコード件数を取得しておく
        cursor = self.db.cursor()
        n_record = cursor.execute("select id from learning_training_messages;")

        datasource = Datasource(type='database')
        all_learning_training_messages = datasource.all_learning_training_messages()
        n_sample = all_learning_training_messages.shape[0]

        # 取得件数が正しいことを確認
        eq_(n_sample, n_record)

    def test_learning_training_messages_from_database(self):
        # テーブルの該当レコード件数を取得しておく
        cursor = self.db.cursor()
        n_record = cursor.execute("select id from learning_training_messages where bot_id=%s;" % self.bot_id)

        datasource = Datasource(type='database')
        learning_training_messages = datasource.learning_training_messages(self.bot_id)
        n_sample = learning_training_messages.shape[0]

        # 取得件数が正しいことを確認
        eq_(n_sample, n_record)

    def test_all_learning_training_messages_from_csv(self):
        # CSVファイルの該当レコード件数を取得しておく
        n_record = 0
        df = pd.read_csv('%s/all.csv' % self.csv_dir_name)
        n_record += df.shape[0]

        datasource = Datasource(type='csv')
        all_learning_training_messages = datasource.all_learning_training_messages()
        n_sample = all_learning_training_messages.shape[0]

        # 取得件数が正しいことを確認
        eq_(n_sample, n_record)

    def test_learning_training_messages_from_csv(self):
        # CSVファイルの該当レコード件数を取得しておく
        df = pd.read_csv('%s/%s' % (self.csv_dir_name, self.csv_file_name))
        n_record = df.shape[0]

        datasource = Datasource(type='csv')
        learning_training_messages = datasource.learning_training_messages(self.bot_id)
        n_sample = learning_training_messages.shape[0]

        # 取得件数が正しいことを確認
        eq_(n_sample, n_record)
