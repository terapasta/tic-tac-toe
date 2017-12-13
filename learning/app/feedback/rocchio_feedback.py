import collections
import traceback
import numpy as np
from app.feedback.base_feedback import BaseFeedback
from app.shared.datasource.datasource import Datasource
from app.shared.constants import Constants
from app.shared.logger import logger


class RocchioFeedback(BaseFeedback):
    # Note: ハイパーパラメータ
    DEFAULT_PARAMS = {
        'query_wait': 1,
        'positive_wait': 0.5,
        'negative_wait': 0.3,
    }

    def __init__(self, bot, datasource: Datasource):
        self.bot = bot
        self.persistence = datasource.persistence
        self.data = {'good': None, 'bad': None}
        fromDb = datasource.learning_parameters.feedback_parameters(self.bot.id, Constants.FEEDBACK_ALGORITHM_ROCCHIO)
        self.parameters = dict(**collections.ChainMap(fromDb, self.DEFAULT_PARAMS))

    def fit_for_good(self, x, y):
        try:
            self.data['good'] = np.sum(x, axis=0) / x.shape[0]
        except:
            logger.debug(traceback.format_exc())

    def fit_for_bad(self, x, y):
        try:
            self.data['bad'] = np.sum(x, axis=0) / x.shape[0]
        except:
            logger.debug(traceback.format_exc())

    def transform_query_vector(self, query_vector):
        logger.debug('parameters : {}'.format(self.parameters))
        new_vector = query_vector * self.parameters['query_wait']

        new_positive = []
        if self.data['good'] is not None:
            new_positive = self.data['good'] * self.parameters['positive_wait']
            new_vector = new_vector + new_positive
            logger.info('reflected positive vector')
        new_negative = []
        if self.data['bad'] is not None:
            new_negative = self.data['bad'] * self.parameters['negative_wait']
            new_vector = new_vector - new_negative
            logger.info('reflected negative vector')

        return new_vector
