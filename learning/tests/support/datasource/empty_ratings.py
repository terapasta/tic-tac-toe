import pandas as pd
from app.shared.base_cls import BaseCls


class EmptyRatings(BaseCls):
    def __init__(self):
        pass

    def all(self):
        return self._empty()

    def by_bot(self, bot_id):
        return self._empty()

    def with_good_by_bot(self, bot_id):
        result = self._empty()
        result['original_question'] = []
        return result

    def with_bad_by_bot(self, bot_id):
        result = self._empty()
        result['original_question'] = []
        return result

    def higher_rate_by_bot_question(self, bot_id, question):
        return self._empty()

    def _empty(self):
        return pd.DataFrame({
            'question': [],
            'question_answer_id': [],
            'level': [],
            'count': [],
        })
