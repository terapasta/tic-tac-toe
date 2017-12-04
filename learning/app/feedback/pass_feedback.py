from app.feedback.base_feedback import BaseFeedback
from app.shared.logger import logger


class PassFeedback(BaseFeedback):
    def __init__(self, bot=None, datasource=None):
        pass

    def fit_for_good(self, x, y):
        logger.info('PASS')

    def fit_for_bad(self, x, y):
        logger.info('PASS')

    def transform_query_vector(self, query_vector):
        logger.info('PASS')
        return query_vector
