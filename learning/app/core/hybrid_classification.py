import inject
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.preprocessing import MinMaxScaler
from app.core.estimator.naive_bayes import NaiveBayes
from app.shared.logger import logger
from app.shared.app_status import AppStatus

from app.core.tokenizer.mecab_tokenizer import MecabTokenizer
from app.core.vectorizer.tfidf_vectorizer import TfidfVectorizer
from app.core.reducer.pass_reducer import PassReducer
from app.core.normalizer.pass_normalizer import PassNormalizer
from app.shared.datasource.datasource import Datasource


# Note: Cosine SimilarityとML Classificationを用いたアルゴリズム
class HybridClassification:
    @inject.params(
        tokenizer=MecabTokenizer,
        vectorizer=TfidfVectorizer,
        reducer=PassReducer,
        normalizer=PassNormalizer,
        datasource=Datasource,
        estimator=NaiveBayes,
        app_status=AppStatus,
    )
    def __init__(self, tokenizer=None, vectorizer=None, reducer=None, normalizer=None, datasource=None, estimator=None, app_status=None):
        self.bot = app_status.current_bot()
        self.tokenizer = tokenizer
        self.vectorizer = vectorizer
        self.reducer = reducer
        self.normalizer = normalizer
        self.estimator = estimator
        self.bot_question_answers_data = datasource.question_answers.by_bot(self.bot.id)
        self.bot_ratings_data = datasource.ratings.by_bot(self.bot.id)

    def fit(self, x, y):
        self.estimator.fit(x, y)

    def predict(self, question_features):
        bot_tokenized_sentences = self.tokenizer.tokenize(self.bot_question_answers_data['question'])
        if len(bot_tokenized_sentences) == 0:
            return self.__no_data
        bot_features = self.vectorizer.transform(bot_tokenized_sentences)
        reduced_vectors = self.reducer.transform(bot_features)
        normalized_vectors = self.normalizer.transform(reduced_vectors)
        similarities = cosine_similarity(normalized_vectors, question_features)
        similarities = similarities.flatten()
        result = self.bot_question_answers_data[['question', 'question_answer_id']].copy()
        result['probability'] = similarities
        return result

    def before_reply(self, sentences):
        logger.info('PASS')
        return sentences

    def after_reply(self, question, data_frame):
        sentences = self.tokenizer.tokenize([question])
        vectors = self.vectorizer.transform(sentences)
        reduced_vectors = self.reducer.transform(vectors)
        normalized_vectors = self.normalizer.transform(reduced_vectors)

        results = self.estimator.predict(normalized_vectors)
        mms = MinMaxScaler(feature_range=(0, 0.3))
        results['probability'] = mms.fit_transform(results['probability'])

        # question_answer_idをキーにしてprobabilityを加算する
        merged_data = data_frame.merge(results, on='question_answer_id', how='left')
        merged_data['probability'] = merged_data['probability_x'] + merged_data['probability_y']
        merged_data = merged_data[['question_answer_id', 'question', 'probability']]

        return merged_data

    def __no_data(self):
        return pd.DataFrame({
            'question': [],
            'question_answer_id': [],
            'probability': [],
        })
