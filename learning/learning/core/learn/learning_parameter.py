from learning.log import logger

class LearningParameter:
    ALGORITHM_LOGISTIC_REGRESSION = 0
    ALGORITHM_NAIVE_BAYES = 1

    def __init__(self, attributes):
        self._include_failed_data = attributes['include_failed_data']
        self._include_tag_vector = attributes.get('include_tag_vector', False)
        self._algorithm = attributes.get('algorithm', self.ALGORITHM_LOGISTIC_REGRESSION)
        self._params_for_algorithm = attributes.get('params_for_algorithm', {})

    @property
    def include_failed_data(self):
        return self._include_failed_data

    @property
    def include_tag_vector(self):
        return self._include_tag_vector

    @property
    def algorithm(self):
        return self._algorithm

    @property
    def params_for_algorithm(self):
        return self._params_for_algorithm
