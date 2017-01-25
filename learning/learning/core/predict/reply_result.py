from learning.log import logger


class ReplyResult:
    def __init__(self, answer_ids, probabilities):
        self.answer_ids = answer_ids
        self.probabilities = probabilities

    def to_dict(self):
        dict = list(map(lambda x: {
            'answer_id': float(x[0]), 'probability': x[1]
        }, sorted(zip(self.answer_ids, self.probabilities[0]), key=lambda x: x[1], reverse=True)))
        self.__out_log_of_results(dict)
        return dict[0:10]

    def __out_log_of_results(self, dict):
        logger.debug('predicted results (order by probability desc)')
        for row in dict:
            logger.debug(row)