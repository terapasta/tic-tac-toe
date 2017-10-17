import inject
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity
from app.shared.logger import logger
from app.shared.current_bot import CurrentBot


class TwoStepsCosineSimilarity:
    @inject.params(bot=CurrentBot)
    def __init__(self, tokenizer, vectorizer, reducer, normalizer, datasource, bot=None):
        self.bot = bot if bot is not None else CurrentBot()
        self.tokenizer = tokenizer
        self.vectorizer = vectorizer
        self.vectorizer_for_qaid = vectorizer.__class__(dump_key='dump_feedback_data_tfidf_vectorizer')
        self.reducer = reducer
        self.normalizer = normalizer
        self.datasource = datasource

    def fit(self, x, y):
        logger.info('learn vocabulary with question_id')
        all_question_answers_data = self.datasource.question_answers.all()
        sencences = self.__tokenize_with_qaid(all_question_answers_data['question'], all_question_answers_data['question_answer_id'].astype(str))
        self.vectorizer_for_qaid.fit(sencences)

    def predict(self, question_features):
        logger.info('first step cosine similarity')
        # TODO: good/badを処理する
        ratings = self.datasource.ratings.by_bot(self.bot.id)
        bot_tokenized_sentences = self.tokenizer.tokenize(ratings['question'])
        bot_features = self.vectorizer.transform(bot_tokenized_sentences)
        reduced_vectors = self.reducer.transform(bot_features)
        normalized_vectors = self.normalizer.transform(reduced_vectors)
        similarities = cosine_similarity(normalized_vectors, question_features)
        similarities = similarities.flatten()
        result = ratings[['question', 'question_answer_id']].copy()
        result['probability'] = similarities
        return result

    def before_reply(self, sentences):
        logger.info('PASS')
        return sentences

    def after_reply(self, question, data_frame):
        logger.info('second step cosine similarity')
        tokenized_questions = None
        tokenized_answers = None
        question_answers = self.datasource.question_answers.by_bot(self.bot.id)

        if len(data_frame) == 0:
            # Note: ratingが付いた類似解答が見つからなかった場合は通常のコサイン類似検索を行う
            logger.info('tokenize question')
            tokenized_questions = self.tokenizer.tokenize([question])
            tokenized_answers = self.tokenizer.tokenize(question_answers['question'])
        else:
            logger.info('tokenize question with question_answer_id')
            top_rating_id = data_frame['question_answer_id'].values[0]
            tokenized_questions = self.__tokenize_with_qaid([question], [str(top_rating_id)])
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
        return 'dump_cosine_similarity'

    def __get_features(self, tokenized_sentences):
        vectorized_features = self.vectorizer_for_qaid.transform(tokenized_sentences)
        reduced_features = self.reducer.transform(vectorized_features)
        normalized_features = self.normalizer.transform(reduced_features)

        return normalized_features

    def __tokenize_with_qaid(self, texts, question_ids):
        logger.info('tokenize all question_answers')
        tokenized_sentences = self.tokenizer.tokenize(texts)
        tokenized_sentences = np.array(tokenized_sentences, dtype=object)
        tokenized_sentences = tokenized_sentences + ' MYOPE_QA_ID:' + question_ids
        return tokenized_sentences
