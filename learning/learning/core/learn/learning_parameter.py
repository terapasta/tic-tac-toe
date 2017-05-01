from learning.log import logger

class LearningParameter:
    ALGORITHM_LOGISTIC_REGRESSION = 0
    ALGORITHM_NAIVE_BAYES = 1
    ALGORITHM_NEURAL_NETWORK = 2

    def __init__(self, attributes):
        self._include_failed_data = attributes['include_failed_data']  # TODO 使われていないパラメータなので削除したい
        self._include_tag_vector = attributes.get('include_tag_vector', False)
        self._use_similarity_classification = attributes.get('use_similarity_classification', False)
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
            学習セットのベクトル構築(TextArray#to_vec)時に、
            利用可能な全Botの学習セットを使用する
        '''
        self._vectorize_using_all_bots = attributes.get('vectorize_using_all_bots', True)

    @property
    def include_failed_data(self):
        return self._include_failed_data

    @property
    def include_tag_vector(self):
        return self._include_tag_vector

    @property
    def use_similarity_classification(self):
        return self._use_similarity_classification

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
    def vectorize_using_all_bots(self):
        return self._vectorize_using_all_bots
