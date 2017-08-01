from learning.core.predict.reply import Reply


class NullReplyResult:
    def to_dict(self):
        return {}

    @property
    def question(self):
        return ''

    @property
    def question_answer_id(self):
        return Reply.CLASSIFY_FAILED_ANSWER_ID

    @property
    def probability(self):
        return 1

    @property
    def question_feature_count(self):
        return 0
