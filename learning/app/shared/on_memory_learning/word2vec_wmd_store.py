from injector import inject
from gensim.models import KeyedVectors
from gensim.similarities import WmdSimilarity
from app.shared.logger import logger
from app.shared.config import Config
from app.shared.custom_errors import NotTrainedError


# Note: modelデータとWmdSimilarityインスタンスをメモリ上に保持するためにシングルトンで実装している
class Word2vecWmdStore:
    __shared_state = {}
    __initialiging = False
    __initialized = False

    @inject
    def __init__(self, question_answers):
        self.__dict__ = self.__shared_state

        if self.__initialiging:
            raise NotTrainedError()
        if not self.__initialized:
            self.__initialiging = True
            self.question_answers = question_answers
            data_path = self.__prepare_corpus_data()
            logger.info('load word2vec model: start')
            self.model = KeyedVectors.load_word2vec_format(data_path, binary=Config().get('word2vec_model_is_binaly'))
            logger.info('load word2vec model: end')
            self.wmd_similarities = {}
            self.tokenizers = {}
            self.__initialiging = False
            self.__initialized = True

    def get_similarities(self, bot_id, tokenizer):
        if bot_id not in self.wmd_similarities:
            self.__build_wmd_similarity(bot_id, tokenizer)
        return self.wmd_similarities[bot_id]

    def fit(self, bot_id, tokenizer):
        self.__build_wmd_similarity(bot_id, tokenizer)

    def __build_wmd_similarity(self, bot_id, tokenizer):
        bot_question_answers_data = self.question_answers.by_bot(bot_id)
        bot_tokenized_sentences = tokenizer.tokenize(bot_question_answers_data['question'])
        self.wmd_similarities[bot_id] = WmdSimilarity(bot_tokenized_sentences, self.model, num_best=10)

    def __prepare_corpus_data(self):
        filename = Config().get('word2vec_model_name')
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
