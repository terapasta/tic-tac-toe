# -*- coding: utf-8 -*-

from collections import Counter
from sklearn.grid_search import GridSearchCV
from learning.core.training_set.training_message_from_csv import TrainingMessageFromCsv
from learning.log import logger
from sklearn.linear_model import LogisticRegression
from sklearn.naive_bayes import MultinomialNB
from learning.core.evaluator import Evaluator
from learning.config.config import Config
from learning.core.training_set.training_message import TrainingMessage
from learning.core.learn.learning_parameter import LearningParameter
from learning.core.persistance import Persistance

class Bot:
    ''' 
        ローカル稼動確認専用のモジュール
        (MySQLdbが使用できない環境向け)
        
        Usage:
            csv_file_path = r'/path/to/file.csv'
            csv_file_encoding = 'Shift_JIS'
            bot = BotForLocalTest(bot_id, learning_parameter)
            evaluator = bot.learn(csv_file_path=csv_file_path, csv_file_encoding=csv_file_encoding)
    '''

    def __init__(self, bot_id, learning_parameter):
        self.bot_id = bot_id
        self.learning_parameter = learning_parameter
        logger.debug('learning_parameter: %s' % vars(learning_parameter))

    def learn(self, csv_file_path=None, csv_file_encoding='UTF-8', sample_weight=None, solver=None):
        logger.debug('start Bot#learn')

        ''' 
            訓練データをCSVファイルから取得
            ロジスティック回帰モデルを使用し学習実行
        '''
        training_set = self.__build_training_set_from_csv(csv_file_path, csv_file_encoding)
        estimator = self.__get_estimator_logit(training_set, sample_weight=sample_weight, solver=solver)
        logger.debug('after Bot#__get_estimator')

        Persistance.dump_model(estimator, self.bot_id)
        Persistance.dump_vectorizer(training_set.body_array.vectorizer, self.bot_id)
        # test_scores_mean = Plotter().plot(estimator, training_set.x, training_set.y)

        ''' 
            学習結果の評価
        '''
        evaluator = Evaluator()
        logger.debug('before Evaluator#evaluate')
        evaluator.evaluate(estimator, training_set.x, training_set.y, threshold=self.learning_parameter.classify_threshold)
        logger.debug('end Bot#learn')

        return evaluator

    def __build_training_set_from_csv(self, csv_file_path, csv_file_encoding):
        '''
            CSVファイルから訓練データを読込
        '''
        training_set = TrainingMessageFromCsv(self.bot_id, csv_file_path, self.learning_parameter, encoding=csv_file_encoding)

        return training_set.build()

    def __get_estimator_logit(self, training_set, sample_weight=None, solver=None):
        ''' 
            ロジスティック回帰モデル専用
        '''
        logger.debug('use algorithm: logistic regression')

        C = self.learning_parameter.params_for_algorithm.get('C', None)
        if C is None:
            logger.debug('learning_parameter has not parameter C')
            # params = {'C': [0.001, 0.01, 0.1, 1, 10, 100, 140, 200]}
            params = {'C': [10, 100, 140, 200]}
            # class_weight = self.__build_class_weight(training_set)
            # grid = GridSearchCV(LogisticRegression(class_weight=class_weight), param_grid=params)
            grid = GridSearchCV(LogisticRegression(), param_grid=params)
            grid.fit(training_set.x, training_set.y)
            estimator = grid.best_estimator_
            logger.debug('best_params_: %s' % grid.best_params_)
        else:
            if solver is None:
                solver = 'liblinear' # default solver on scikit-learn

            logger.debug('learning_parameter has parameter C')
            estimator = LogisticRegression(C=C, solver=solver)
            estimator.fit(training_set.x, training_set.y, sample_weight=sample_weight)

        return estimator
