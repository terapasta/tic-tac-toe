import inject
import numpy as np
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
from app.shared.logger import logger
from app.shared.current_bot import CurrentBot
from app.shared.constants import Constants


# Note: ユーザーの評価を検索結果に反映したコサイン類似検索
#     ratingsテーブル内を類似検索し類似度の高いレコードのquestion_answer_idを使ってquestion_answersに類似検索をかける
class TwoStepsCosineSimilarity:
    FIRST_STEP_THRESHOLD = 0.5
    BAD_QA_ID = '0'

    @inject.params(bot=CurrentBot)
    def __init__(self, tokenizer, vectorizer, reducer, normalizer, datasource, bot=None):
        self.bot = bot if bot is not None else CurrentBot()
        self.tokenizer = tokenizer
        self.vectorizer = vectorizer
        self.vectorizer_for_qaid = vectorizer.__class__(dump_key='two_steps_tfidf_vectorizer')
        self.reducer = reducer
        self.normalizer = normalizer
        self.datasource = datasource

    def fit(self, x, y):
        logger.info('learn vocabulary with question_id')
        question_answers = self.datasource.question_answers.all()
        ratings = self.datasource.ratings.all()
        all_questions = pd.concat([question_answers[['question', 'question_answer_id']], ratings[['question', 'question_answer_id']]])
        sentences = self.__tokenize_with_qaid(all_questions['question'], all_questions['question_answer_id'].astype(str))
        self.vectorizer_for_qaid.fit(sentences)

    def predict(self, question_features):
        logger.info('first step cosine similarity')

        # Note: ratingsテーブルから類似questionを検索する
        ratings = self.datasource.ratings.by_bot(self.bot.id)
        if len(ratings) == 0:
            return self.__no_data()
        bot_tokenized_sentences = self.tokenizer.tokenize(ratings['question'])
        bot_features = self.vectorizer.transform(bot_tokenized_sentences)
        reduced_vectors = self.reducer.transform(bot_features)
        normalized_vectors = self.normalizer.transform(reduced_vectors)
        similarities = cosine_similarity(normalized_vectors, question_features)
        similarities = similarities.flatten()
        result = ratings[['question']].copy()
        result['probability'] = similarities
        result = result.sort_values(by='probability', ascending=False)

        # Note: 算出したquestionをキーにして評価の多いratingsを取得する
        top_probability = result['probability'].values[0]
        if len(result) == 0 or top_probability < self.FIRST_STEP_THRESHOLD:
            return self.__no_data()
        most_similar_question = result['question'].values[0]
        higher_ratings = self.datasource.ratings.higher_rate_by_bot_question(self.bot.id, most_similar_question)
        if len(higher_ratings) == 0:
            return self.__no_data()
        top_rating_qaid = higher_ratings['question_answer_id'].values[0]
        top_rating_level = higher_ratings['level'].values[0]
        return pd.DataFrame({
            'question': [most_similar_question],
            'question_answer_id': [top_rating_qaid],
            'level': [top_rating_level],
            'probability': [top_probability],
        })

    def before_reply(self, sentences):
        logger.info('PASS')
        return sentences

    def after_reply(self, question, data_frame):
        logger.info('second step cosine similarity')
        logger.debug(data_frame)
        tokenized_questions = None
        tokenized_answers = None
        question_answers = self.datasource.question_answers.by_bot(self.bot.id)

        if len(data_frame) == 0:
            # Note: ratingが付いた類似解答が見つからなかった場合は通常のコサイン類似検索を行う
            logger.info('tokenize question')
            tokenized_questions = self.tokenizer.tokenize([question])
            tokenized_answers = self.tokenizer.tokenize(question_answers['question'])
        else:
            # Note: question_answer_idを付与してコサイン類似検索を行う
            logger.info('tokenize question with question_answer_id')
            top_rating_id = data_frame['question_answer_id'].values[0]
            top_rating_level = data_frame['level'].values[0]
            logger.debug('rating level:{} ({}:good, {}bad)'.format(top_rating_level, Constants.RATING_GOOD, Constants.RATING_BAD))
            if top_rating_level == Constants.RATING_GOOD:
                tokenized_questions = self.__tokenize_with_qaid([question], [str(top_rating_id)])
            else:
                tokenized_questions = self.__tokenize_with_qaid([question], [self.BAD_QA_ID])
            tokenized_answers = self.__tokenize_with_qaid(question_answers['question'], question_answers['question_answer_id'].astype(str))
        logger.debug(tokenized_questions)

        question_features = self.__get_features(tokenized_questions)
        answer_features = self.__get_features(tokenized_answers)

        logger.info('cosine similarity')
        similarities = cosine_similarity(answer_features, question_features)
        similarities = similarities.flatten()
        results = question_answers[['question', 'question_answer_id']].copy()
        results['probability'] = similarities

        logger.info('sort')
        results = results.sort_values(by='probability', ascending=False)
        return results

    @property
    def dump_key(self):
        return 'two_steps_cosine_similarity'

    def __get_features(self, tokenized_sentences):
        vectorized_features = self.vectorizer_for_qaid.transform(tokenized_sentences)
        reduced_features = self.reducer.transform(vectorized_features)
        normalized_features = self.normalizer.transform(reduced_features)

        return normalized_features

    def __tokenize_with_qaid(self, texts, question_ids):
        tokenized_sentences = self.tokenizer.tokenize(texts)
        tokenized_sentences = np.array(tokenized_sentences, dtype=object)
        tokenized_sentences = tokenized_sentences + ' MYOPE_QA_ID:' + question_ids
        return tokenized_sentences

    def __no_data(self):
        return pd.DataFrame({
            'question': [],
            'question_answer_id': [],
            'level': [],
            'probability': [],
        })
