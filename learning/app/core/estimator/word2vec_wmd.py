from gensim.models import KeyedVectors
from gensim.similarities import WmdSimilarity

from app.shared.app_status import AppStatus
from app.shared.logger import logger


class Word2vecWmd:
    __shared_state = {}
    __initialized = False

    def __init__(self, tokenizer, datasource):
        self.__dict__ = self.__shared_state
        self.tokenizer = tokenizer
        self.datasource = datasource

        if not self.__initialized:
            logger.info('load word2vec model: start')
            self.model = KeyedVectors.load_word2vec_format('dumps/entity_vector.model.bin', binary=True)
            logger.info('load word2vec model: end')
            self.wmd_similarities = {}
            self.__initialized = True
        if self.__bot_id() not in self.wmd_similarities:
            self.__build_wmd_similarity()

    def fit(self, x, y):
        self.__build_wmd_similarity()

    def predict(self, question_features):
        bot_question_answers_data = self.datasource.question_answers.by_bot(self.__bot_id())

        # NOTE: 形態素解析結果がスペース区切りの文字列になっていると、複数inputの類似検索が出来ないため一旦インデックス0を指定している
        result = self.wmd_similarities[self.__bot_id()][question_features[0]]

        indices = [x[0] for x in result]
        df = bot_question_answers_data.iloc[indices].copy()
        df = df[['question', 'question_answer_id']]
        df['probability'] = [x[1] for x in result]
        return df

    def before_reply(self, sentences):
        logger.info('PASS')
        return sentences

    def after_reply(self, question, data_frame):
        logger.info('PASS')
        return data_frame

    def __bot_id(self):
        return AppStatus().current_bot().id

    def __build_wmd_similarity(self):
        bot_question_answers_data = self.datasource.question_answers.by_bot(self.__bot_id())
        bot_tokenized_sentences = self.tokenizer.tokenize(bot_question_answers_data['question'])
        self.wmd_similarities[self.__bot_id()] = WmdSimilarity(bot_tokenized_sentences, self.model, num_best=10)
