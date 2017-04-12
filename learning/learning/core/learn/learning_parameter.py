from learning.log import logger

class LearningParameter:
    ALGORITHM_LOGISTIC_REGRESSION = 0
    ALGORITHM_NAIVE_BAYES = 1

    def __init__(self, attributes):
        self._include_failed_data = attributes['include_failed_data']
        self._include_tag_vector = attributes.get('include_tag_vector', False)
        self._classify_threshold = attributes.get('classify_threshold')
        self._algorithm = attributes.get('algorithm', self.ALGORITHM_LOGISTIC_REGRESSION)
        self._params_for_algorithm = attributes.get('params_for_algorithm', {})
        if self._params_for_algorithm is None:
            self._params_for_algorithm = {}

        '''
            学習(fit)時に、
            学習セットから分離させたいラベルを指定する
        '''
        self._excluded_labels_for_fitting = attributes.get('excluded_labels_for_fitting')
        if self._excluded_labels_for_fitting is None:
            self._excluded_labels_for_fitting = []

        '''
            分離されたラベルで予測実行時、
            回答失敗と判定される probability のしきい値を指定
        '''
        self._failure_score_threshold = attributes.get('failure_score_threshold')

    @property
    def include_failed_data(self):
        return self._include_failed_data

    @property
    def include_tag_vector(self):
        return self._include_tag_vector

    @property
    def classify_threshold(self):
        return self._classify_threshold

    @property
    def algorithm(self):
        return self._algorithm

    @property
    def params_for_algorithm(self):
        return self._params_for_algorithm

    @property
    def excluded_labels_for_fitting(self):
        return self._excluded_labels_for_fitting

    @property
    def failure_score_threshold(self):
        return self._failure_score_threshold
