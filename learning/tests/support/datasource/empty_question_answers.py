import pandas as pd
from app.shared.base_cls import BaseCls


class EmptyQuestionAnswers(BaseCls):
    def __init__(self):
        pass

    def all(self):
        return self._empty()

    def by_bot(self, bot_id):
        return self._empty()

    def _empty(self):
        return pd.DataFrame({
            'question': [],
            'question_answer_id': [],
        })
