class NullReplyResult:
    CLASSIFY_FAILED_ANSWER_ID = 0

    def to_dict(self):
        return {}

    @property
    def answer_id(self):
        return self.CLASSIFY_FAILED_ANSWER_ID

    @property
    def probability(self):
        return 1
