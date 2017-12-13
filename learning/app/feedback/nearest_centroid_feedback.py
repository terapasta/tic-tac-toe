import collections
import traceback
from sklearn.exceptions import NotFittedError
from sklearn.neighbors.nearest_centroid import NearestCentroid
from app.feedback.base_feedback import BaseFeedback
from app.shared.datasource.datasource import Datasource
from app.shared.constants import Constants
from app.shared.logger import logger


class NearestCentroidFeedback(BaseFeedback):
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
        self.data = {'good': None, 'bad': None}
        fromDb = datasource.learning_parameters.feedback_parameters(self.bot.id, Constants.FEEDBACK_ALGORITHM_ROCCHIO)
        self.parameters = dict(**collections.ChainMap(fromDb, self.DEFAULT_PARAMS))

    def fit_for_good(self, x, y):
        try:
            self.estimator_for_good.fit(x, y)
            self.data['good'] = dict(zip(y, x))
        except:
            logger.debug(traceback.format_exc())

    def fit_for_bad(self, x, y):
        try:
            self.estimator_for_bad.fit(x, y)
            self.data['bad'] = dict(zip(y, x))
        except:
            logger.debug(traceback.format_exc())

    def transform_query_vector(self, query_vector):
        logger.debug('parameters : {}'.format(self.parameters))
        new_vector = query_vector * self.parameters['query_wait']

        try:
            posi_result = self.estimator_for_good.predict(query_vector)
            logger.debug('nearest positive qaid: {}'.format(posi_result[0]))
            positive_vectors = self.data['good'][posi_result[0]]
            new_positive = positive_vectors * self.parameters['positive_wait']
            new_vector = new_vector + new_positive
            logger.info('reflected positive vector')
        except NotFittedError as e:
            logger.debug(traceback.format_exc())
            logger.debug('no good feedback')

        try:
            nega_result = self.estimator_for_bad.predict(query_vector)
            logger.debug('nearest negative qaid: {}'.format(nega_result[0]))
            negative_vectors = self.data['bad'][nega_result[0]]
            new_negative = negative_vectors * self.parameters['negative_wait']
            new_vector = new_vector - new_negative
            logger.info('reflected negative vector')
        except NotFittedError as e:
            logger.debug(traceback.format_exc())
            logger.debug('no bad feedback')

        return new_vector
