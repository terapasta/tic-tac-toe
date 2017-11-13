import pandas as pd


class EmptyRatings:
    def __init__(self):
        pass

    def all(self):
        return self._empty()

    def by_bot(self, bot_id):
        return self._empty()

    def higher_rate_by_bot_question(self, bot_id, question):
        return self._empty()

    def _empty(self):
        return pd.DataFrame({
            'question': [],
            'question_answer_id': [],
            'level': [],
            'count': [],
        })