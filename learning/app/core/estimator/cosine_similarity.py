from sklearn.metrics.pairwise import cosine_similarity


class CosineSimilarity:
    def __init__(self):
        pass

    def fit(self):
        pass

    def predict(self, question_features, all_features):
        similarities = cosine_similarity(all_features, question_features)
        similarities = similarities.flatten()
        return similarities
