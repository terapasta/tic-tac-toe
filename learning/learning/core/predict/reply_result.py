from learning.log import logger


class ReplyResult:
    def __init__(self, answer_ids, probabilities):
        self.answer_ids = answer_ids
        self.probabilities = probabilities
        self._result = self.__sort()

    def to_dict(self):
        d = self._result[0:10]
        self.__out_log_of_results(d)
        return d

    @property
    def answer_id(self):
        if len(self.answer_ids) > 0:
            return self._result[0]['answer_id']


    @property
    def probability(self):
        if len(self.probabilities) > 0:
            return self._result[0]['probability']

    def __sort(self):
        dict = list(map(lambda x: {
            'answer_id': float(x[0]), 'probability': x[1]
        }, sorted(zip(self.answer_ids, self.probabilities[0]), key=lambda x: x[1], reverse=True)))
        return dict

    def __out_log_of_results(self, dict):
        logger.debug('predicted results (order by probability desc)')
        for row in dict:
            logger.debug(row)