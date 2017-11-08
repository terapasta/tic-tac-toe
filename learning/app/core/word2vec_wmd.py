import inject
from gensim.models import KeyedVectors
from gensim.similarities import WmdSimilarity

from app.shared.app_status import AppStatus
from app.shared.logger import logger
from app.shared.config import Config

from app.core.tokenizer.mecab_tokenizer_with_split import MecabTokenizerWithSplit
from app.shared.datasource.datasource import Datasource
from app.core.base_core import BaseCore


# Note: modelデータとWmdSimilarityインスタンスをメモリ上に保持するためにシングルトンで実装している
class Word2vecWmd(BaseCore):
    __shared_state = {}
    __initialized = False

    @inject.params(
        config=Config,
        tokenizer=MecabTokenizerWithSplit,
        datasource=Datasource,
    )
    def __init__(self, tokenizer=None, datasource=None, config=None):
        self.__dict__ = self.__shared_state
        self.config = config
        self.tokenizer = tokenizer
        self.question_answers = datasource.question_answers

        if not self.__initialized:
            data_path = self.__prepare_corpus_data()
            logger.info('load word2vec model: start')
            self.model = KeyedVectors.load_word2vec_format(data_path, binary=self.config.get('word2vec_model_is_binaly'))
            logger.info('load word2vec model: end')
            self.wmd_similarities = {}
            self.__initialized = True
        if self.__bot_id() not in self.wmd_similarities:
            self.__build_wmd_similarity()

    def fit(self, x, y):
        self.__build_wmd_similarity()

    def predict(self, question_features):
        bot_question_answers_data = self.question_answers.by_bot(self.__bot_id())

        result = self.wmd_similarities[self.__bot_id()][question_features]

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
        bot_question_answers_data = self.question_answers.by_bot(self.__bot_id())
        bot_tokenized_sentences = self.tokenizer.tokenize(bot_question_answers_data['question'])
        self.wmd_similarities[self.__bot_id()] = WmdSimilarity(bot_tokenized_sentences, self.model, num_best=10)

    def __prepare_corpus_data(self):
        filename = self.config.get('word2vec_model_name')
        tarfile_path = 'dumps/{}.tar.bz2'.format(filename)
        model_path = 'dumps/{}'.format(filename)
        logger.debug('word2vec model path:{}'.format(model_path))
        import os
        if not os.path.exists(model_path):
            import urllib.request
            logger.info('downloading word2vec model')
            urllib.request.urlretrieve('https://s3-ap-northeast-1.amazonaws.com/my-ope.net/datasets/{}.tar.bz2'.format(filename), tarfile_path)
            logger.info('extracting word2vec model')
            import tarfile
            tar = tarfile.open(tarfile_path, 'r:bz2')
            tar.extractall('dumps')
            logger.info('You got word2vec model')

        return model_path
