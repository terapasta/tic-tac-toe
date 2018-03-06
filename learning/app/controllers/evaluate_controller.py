from app.shared.logger import logger
from app.shared.base_cls import BaseCls


class EvaluateController(BaseCls):
    def __init__(self, context):
        self.factory = context.get_factory()
        self.bot = context.current_bot
        self.pass_feedback = context.pass_feedback

    def perform(self):
        pass
