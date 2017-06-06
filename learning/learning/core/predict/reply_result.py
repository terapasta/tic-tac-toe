from learning.log import logger


class ReplyResult:

    def __init__(self, answer_ids, probabilities, question, question_feature_count, question_answer_ids):
        self.question = question
        self.question_feature_count = question_feature_count
        self._answer_ids = answer_ids
        self._probabilities = probabilities
        self._question_answer_ids = question_answer_ids
        self._result = self.__sort()

    def to_dict(self):
        d = self.__limited_result()
        return d

    @property
    def answer_id(self):
        if len(self._answer_ids) > 0:
            return self._result[0]['answer_id']

    @property
    def probability(self):
        from learning.core.predict.reply import Reply

        if len(self._probabilities) > 0:
            if self.answer_id == Reply.CLASSIFY_FAILED_ANSWER_ID:
                return 1
            else:
                return self._result[0]['probability']

    def out_log_of_results(self):
        dict = self.__limited_result()
        logger.debug('question: %s' % self.question)
        logger.debug('question_feature_count: %s' % self.question_feature_count)
        logger.debug('predicted results (order by probability desc)')
        for row in dict:
            logger.debug(row)

    def __sort(self):
        dict = list(map(lambda x: {
            'answer_id': float(x[0]), 'probability': x[1], 'question_answer_id': x[2]
        }, sorted(zip(self._answer_ids, self._probabilities, self._question_answer_ids), key=lambda x: x[1], reverse=True)))
        return dict

    def __limited_result(self):
        return self._result[0:10]
