from app.shared.logger import logger
from app.shared.base_cls import BaseCls
from app.shared.benchmark import Benchmark
from app.shared.constants import Constants
from app.shared.document_generator import DocumentGenerator
from app.controllers.learn_controller import LearnController
from app.controllers.reply_controller import ReplyController
from app.core.evaluator.mcll_evaluator import McllEvaluator
from app.core.evaluator.accuracy_evaluator import AccuracyEvaluator

import csv
import logging


class BenchmarkController(BaseCls):
    """
    BenchmarkController は内部的に LearnController と ReplyController を呼び出す
    """
    def __init__(self, context):
        self.bot = context.current_bot
        self.factory = context.get_factory()

        context.phase = Constants.PHASE_LEARNING
        self.learn_controller = LearnController(context)

        context.phase = Constants.PHASE_REPLYING
        self.reply_controller = ReplyController(context)

    def perform(self):
        # 評価前に学習する
        logger.setLevel(logging.WARNING)
        self.learn_controller.perform()

        logger.setLevel(logging.INFO)
        logger.info('load test data for evaluation')

        expected, actual = self._load_test_data()

        # multi-class logarithmic loss
        mcll = self._calc_mcll(expected, actual)

        # accuracy
        accuracy = self._calc_accuracy(expected, actual)

        return {
            'mcll': mcll,
            'accuracy': accuracy,
        }

    def _load_test_data(self):
        # reply用のコントローラを使うので、ログは警告のみ表示させる
        logger.setLevel(logging.WARNING)

        # ベンチマーク用のクラス
        bench = Benchmark()

        # テストケースを読み込む
        testcase = bench.get_testcase()

        y_expected = []
        y_actual = []
        for t in testcase:
            # bot_id が指定されていない場合はスキップする
            if (not self.bot.id is None) and (t['bot_id'] is None):
                continue

            # 対象のボットに関するテストデータのみ使用する
            if self.bot.id == int(t['bot_id']):
                # bot からのリプライを取得
                reply = self.reply_controller.perform(t['question'])

                # dict形式の list から dict へと変換する
                test_data = self._dict_array_to_dict(reply['results'], 'question_answer_id', 'probability')

                # テストデータ（入力）は、各回答の確率分布
                y_actual.append(test_data)

                # テストデータ（出力）は、回答のID
                y_expected.append(t['question_answer_id'])

        # INFOレベルに戻す
        logger.setLevel(logging.INFO)

        return (y_expected, y_actual)

    def _calc_accuracy(self, expected, actual):
        evaluator = AccuracyEvaluator()
        actual = [self._max_probability_id(x) for x in actual]
        accuracy = evaluator.evaluate(expected, actual)

        logger.info("accuracy: %3.6f" % accuracy)

        return accuracy

    def _calc_mcll(self, expected, actual):
        evaluator = McllEvaluator()
        mcll = evaluator.evaluate(expected, actual)

        logger.info("multi-class logarithmic loss: %3.6f" % mcll)

        return mcll

    def _dict_array_to_dict(self, dict_array, key_of_key, key_of_value):
        dict = {}
        for item in dict_array:
            key = str(item[key_of_key])
            value = item[key_of_value]
            dict[key] = value
        return dict

    def _max_probability_id(self, probs):
        #
        # dict.items() は dict の key-value を list形式で返す
        # これを lambda式を使って value が最大値をとる要素を取り出し、
        # その内の key を返却する
        #
        # e.g.
        # ----
        # >>> a = {'a': 0.2, 'b': 0.3, 'c': 1.0, 'd': 0.2}
        # >>> a.items()
        # dict_items([('c', 1.0), ('a', 0.2), ('d', 0.2), ('b', 0.3)])
        # >>> max(a.items(), key=lambda x:x[1])
        # ('c', 1.0)
        # >>> max(a.items(), key=lambda x:x[1])[0]
        # 'c'
        #
        return max(probs.items(), key=lambda x:x[1])[0]
