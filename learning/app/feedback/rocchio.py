import collections
import traceback
from sklearn.neighbors.nearest_centroid import NearestCentroid
from app.feedback.base_feedback import BaseFeedback
from app.shared.datasource.datasource import Datasource
from app.shared.constants import Constants
from app.shared.logger import logger


class Rocchio(BaseFeedback):
    # Note: ハイパーパラメータ
    DEFAULT_PARAMS = {
        'query_wait': 1,
        'positive_wait': 0.5,
        'negative_wait': 0.3,
    }

    def __init__(self, bot, datasource: Datasource):
        self.bot = bot
        self.estimator_for_good = NearestCentroid()
        self.estimator_for_bad = NearestCentroid()
        self.persistence = datasource.persistence
        self.data = {'good': None, 'bad': None}
        fromDb = datasource.learning_parameters.feedback_parameters(self.bot.id, Constants.FEEDBACK_ALGORITHM_ROCCHIO)
        self.parameters = dict(**collections.ChainMap(fromDb, self.DEFAULT_PARAMS))

    def fit_for_good(self, x, y):
        try:
            logger.debug(x.shape)
            self.estimator_for_good.fit(x, y)
            self.data['good'] = dict(zip(y, x))
        except:
            logger.debug(traceback.format_exc())

    def fit_for_bad(self, x, y):
        try:
            logger.debug(x.shape)
            self.estimator_for_bad.fit(x, y)
            self.data['bad'] = dict(zip(y, x))
        except:
            logger.debug(traceback.format_exc())

    def transform_query_vector(self, query_vector):
        logger.debug('parameters : {}'.format(self.parameters))
        new_vector = query_vector * self.parameters['query_wait']

        try:
            posi_result = self.estimator_for_good.predict(query_vector)
            logger.debug('nearlest positive qaid: {}'.format(posi_result['question_answer_id'][0]))
            positive_vectors = self.data['good'][posi_result['question_answer_id'][0]]
            new_positive = positive_vectors * self.parameters['positive_wait']
            new_vector = new_vector + new_positive
        except:
            pass

        try:
            nega_result = self.estimator_for_bad.predict(query_vector)
            logger.debug('nearlest negative qaid: {}'.format(nega_result['question_answer_id'][0]))
            negative_vectors = self.data['bad'][nega_result['question_answer_id'][0]]
            new_negative = negative_vectors * self.parameters['negative_wait']
            new_vector = new_vector - new_negative
        except:
            pass

        return new_vector
