from injector import inject
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
from app.shared.logger import logger

from app.shared.custom_errors import NotTrainedError
from app.shared.datasource.datasource import Datasource
from app.core.base_core import BaseCore


class CosineSimilarity(BaseCore):
    @inject
    def __init__(self, bot, datasource: Datasource):
        self.bot = bot
        self.persistence = datasource.persistence
        self.data = self.persistence.load(self.dump_key)

    def fit(self, x, y):
        self.data = {
          'x': x,
          'y': y,
        }
        self.persistence.dump(self.data, self.dump_key)

    def predict(self, question_features):
        if self.data is None:
            raise NotTrainedError()
        similarities = cosine_similarity(self.data['x'], question_features)
        similarities = similarities.flatten()
        result = pd.DataFrame({
            'question_answer_id': self.data['y'],
            'probability': similarities
        })
        return result

    def before_reply(self, sentences):
        logger.info('PASS')
        return sentences

    def after_reply(self, question, data_frame):
        logger.info('PASS')
        return data_frame

    @property
    def dump_key(self):
        return 'sk_cosine_similarity'
