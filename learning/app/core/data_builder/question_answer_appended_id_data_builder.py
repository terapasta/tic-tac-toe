import inject
from app.shared.logger import logger
from app.shared.constants import Constants
from app.shared.current_bot import CurrentBot
import numpy as np


class QuestionAnswerAppendedIdDataBuiler:
    @inject.params(bot=CurrentBot)
    def __init__(self, tokenizer, datasource, bot=None):
        self.bot = bot if bot is not None else CurrentBot()
        self.tokenizer = tokenizer
        self.datasource = datasource

    def build_tokenized_vocabularies(self):
        all_question_answers_data = self.datasource.question_answers.all()
        return self.__tokenize(all_question_answers_data)

    def build_learning_data(self, bot_id):
        raw_data = self.datasource.question_answers.by_bot(bot_id)
        bot_tokenized_sentences = self.__tokenize(raw_data)

        # Note: 空のテキストにラベル0を対応付けるために強制的にトレーニングセットを追加
        bot_tokenized_sentences = np.array(bot_tokenized_sentences)
        bot_tokenized_sentences = np.append(bot_tokenized_sentences, [''] * Constants.COUNT_OF_APPEND_BLANK)
        question_answer_ids = np.array(raw_data['question_answer_id'], dtype=np.int)
        question_answer_ids = np.append(question_answer_ids, [Constants.CLASSIFY_FAILED_ANSWER_ID] * Constants.COUNT_OF_APPEND_BLANK)

        return bot_tokenized_sentences, question_answer_ids

    # def build_for_reply(self, sentences, tokenizer, bot_id):
    #     tokenized_sentences = tokenizer.tokenize(sentences)

    #     factory = CosineSimilarityFactory(
    #         data_builder=FeedbackDataBuilder(),
    #         vectorizer=TfidfVectorizer(dump_key='dump_feedbacks_tfidf_vectorizer')
    #     )

    #     tokenized_sentences = factory.get_data_builder().build_by_bot(
    #         factory.get_datasource(), factory.get_tokenizer(), bot_id)
    #     logger.debug(tokenized_sentences)

    #     logger.info('vectorize question')
    #     vectorized_features = factory.get_vectorizer().transform(tokenized_sentences)
    #     logger.debug(vectorized_features)

    #     logger.info('reduce question')
    #     reduced_features = factory.get_reducer().transform(vectorized_features)

    #     logger.info('normalize question')
    #     normalized_features = factory.get_normalizer().transform(reduced_features)

    #     logger.info('predict')
    #     data_frame = factory.get_estimator().predict(normalized_features)

    #     logger.info('sort')
    #     data_frame = data_frame.sort_values(by='probability', ascending=False)
    #     results = data_frame.to_dict('records')[:10]

    #     # TODO:
    #     # フィードバックデータにコサイン類似検索をかけてsentencesにMYOPE_QA_IDを付与する

    def __tokenize(self, df):
        logger.info('tokenize all question_answers')
        tokenized_sentences = self.tokenizer.tokenize(df['question'])
        tokenized_sentences = np.array(tokenized_sentences, dtype=object)
        tokenized_sentences = tokenized_sentences + ' MYOPE_QA_ID:' + df['question_answer_id'].astype(str)
        return tokenized_sentences
