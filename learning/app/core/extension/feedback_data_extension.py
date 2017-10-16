import inject
from app.shared.logger import logger
from app.shared.current_bot import CurrentBot
from app.shared.datasource.datasource import Datasource
import numpy as np


class FeedbackDataExtension:
    @inject.params(datasource=Datasource, bot=CurrentBot)
    def __init__(self, tokenizer, vectorizer, datasource=None, bot=None):
        self.bot = bot if bot is not None else CurrentBot()
        self.datasource = datasource
        self.tokenizer = tokenizer
        self.vectorizer = vectorizer

    def learn(self, bot_id):
        # ID付きボキャブラリの生成
        all_question_answers_data = self.datasource.question_answers.all()
        sencences = self.__tokenize(all_question_answers_data)
        self.vectorizer.fit(sencences)

    # def before_reply(self, sentences):
    #     tokenized_sentences = self.tokenizer.tokenize(sentences)

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

        # TODO:
        # フィードバックデータにコサイン類似検索をかけてsentencesにMYOPE_QA_IDを付与する

    def __tokenize(self, df):
        logger.info('tokenize all question_answers')
        tokenized_sentences = self.tokenizer.tokenize(df['question'])
        tokenized_sentences = np.array(tokenized_sentences, dtype=object)
        tokenized_sentences = tokenized_sentences + ' MYOPE_QA_ID:' + df['question_answer_id'].astype(str)
        return tokenized_sentences
