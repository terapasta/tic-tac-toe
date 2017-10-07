from app.core.vectorizer.tfidf_vectorizer import TfidfVectorizer
from app.factories.cosine_similarity_factory import CosineSimilarityFactory
from app.shared.logger import logger
import numpy as np


class FeedbackDataBuilder:
    # raw_data = None
    #

    def build(self, datasource):
        return False

    # def build(self, datasource, tokenizer):
    #     all_question_answers_data = datasource.question_answers.all()
    #     return self.__tokenize(all_question_answers_data, tokenizer)
    #
    #
    # def build_by_bot(self, datasource, tokenizer, bot_id):
    #     self.raw_data = datasource.question_answers.by_bot(bot_id)
    #     return self.__tokenize(self.raw_data, tokenizer)
    #
    #
    # def build_for_reply(self, sentences, tokenizer, bot_id):
    #     tokenized_sentences = tokenizer.tokenize(sentences)
    #
    #     factory = CosineSimilarityFactory(
    #         data_builder=FeedbackDataBuilder(),
    #         vectorizer=TfidfVectorizer(dump_key='dump_feedbacks_tfidf_vectorizer')
    #     )
    #
    #     tokenized_sentences = factory.get_data_builder().build_by_bot(
    #         factory.get_datasource(), factory.get_tokenizer(), bot_id)
    #     logger.debug(tokenized_sentences)
    #
    #     logger.info('vectorize question')
    #     vectorized_features = factory.get_vectorizer().transform(tokenized_sentences)
    #     logger.debug(vectorized_features)
    #
    #     logger.info('reduce question')
    #     reduced_features = factory.get_reducer().transform(vectorized_features)
    #
    #     logger.info('normalize question')
    #     normalized_features = factory.get_normalizer().transform(reduced_features)
    #
    #     logger.info('predict')
    #     data_frame = factory.get_estimator().predict(normalized_features)
    #
    #     logger.info('sort')
    #     data_frame = data_frame.sort_values(by='probability', ascending=False)
    #     results = data_frame.to_dict('records')[:10]
    #
    #     # TODO:
    #     # フィードバックデータにコサイン類似検索をかけてsentencesにMYOPE_QA_IDを付与する
    #
    # def __tokenize(self, df, tokenizer):
    #     logger.info('tokenize all question_answers')
    #     tokenized_sentences = tokenizer.tokenize(df['question'])
    #     tokenized_sentences = np.array(tokenized_sentences, dtype=object)
    #     tokenized_sentences = tokenized_sentences + ' MYOPE_QA_ID:' + df['question_answer_id'].astype(str)
    #     return tokenized_sentences
    #
