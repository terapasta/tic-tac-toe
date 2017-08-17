from sklearn.metrics.pairwise import cosine_similarity
from app.shared.logger import logger


class CosineSimilarity:
    def __init__(self):
        pass

    def fit(self, x, y):
        logger.info('PASS')
        pass

    def predict(self, question_features, all_features):
        similarities = cosine_similarity(all_features, question_features)
        similarities = similarities.flatten()
        return similarities
