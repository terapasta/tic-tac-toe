from app.shared.logger import logger
from app.shared.base_cls import BaseCls
from app.controllers.learn_controller import LearnController
from app.controllers.reply_controller import ReplyController
from app.core.evaluator.mcll_evaluator import McllEvaluator

import csv
import logging

class EvaluateController(BaseCls):
    """
    EvaluateController は LearnController と共通のメソッドを持つ
    """
    def __init__(self, context):
        self.bot = context.current_bot
        self.factory = context.get_factory()
        self.learn_controller = LearnController(context)
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

        return {
            'mcll': mcll,
        }

    def _load_test_data(self):
        # reply用のコントローラを使うので、ログは警告のみ表示させる
        logger.setLevel(logging.WARNING)

        y_expected = []
        y_actual = []
        with open('fixtures/test_messages.csv') as f:
            reader = csv.DictReader(f, delimiter=',')
            for data in reader:
                # 対象のボットに関するテストデータのみ使用する
                if self.bot.id == int(data['bot_id']):
                    # テストデータ（入力）は、各回答の確率分布
                    reply = self.reply_controller.perform(data['question'])
                    test_data = {}
                    for r in reply['results']:
                        test_data[r['question_answer_id']] = r['probability']
                    y_actual.append(test_data)

                    # テストデータ（出力）は、回答のID
                    y_expected.append(data['question_answer_id'])

        # INFOレベルに戻す
        logger.setLevel(logging.INFO)

        return (y_expected, y_actual)

    def _calc_mcll(self, expected, actual):
        evaluator = McllEvaluator()
        mcll = evaluator.evaluate(expected, actual)

        logger.info("multi-class logarithmic loss: %3.6f" % mcll)

        return mcll
