from learning.core.predict.reply import Reply


class NullReplyResult:
    def to_dict(self):
        return {}

    @property
    def answer_id(self):
        return Reply.CLASSIFY_FAILED_ANSWER_ID

    @property
    def probability(self):
        return 1
