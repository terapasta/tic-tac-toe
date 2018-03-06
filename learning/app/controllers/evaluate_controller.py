from app.shared.logger import logger
from app.shared.base_cls import BaseCls
from app.controllers.learn_controller import LearnController


class EvaluateController(LearnController):
    """
    EvaluateController は LearnController と共通のメソッドを持つ
    """
    def _evaluate(self):
        # 評価値は学習時の物を使用する
        evaluation = super()._evaluate()

        return evaluation
