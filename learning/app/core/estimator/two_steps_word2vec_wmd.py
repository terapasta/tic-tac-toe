import numpy as np
import pandas as pd
from gensim.models import KeyedVectors
from gensim.similarities import WmdSimilarity
from app.shared.logger import logger
from app.shared.app_status import AppStatus
from app.shared.constants import Constants


# Note: ユーザーの評価を検索結果に反映したWord2vec
#     ratingsテーブル内を類似検索し類似度の高いレコードのquestion_answer_idを使ってquestion_answersに類似検索をかける
class TwoStepsWord2vecWmd:
    FIRST_STEP_THRESHOLD = 0.5
    BAD_QA_ID = '0'
    __shared_state = {}
    __initialized = False

    def __init__(self, tokenizer, datasource):
        self.__dict__ = self.__shared_state
        self.tokenizer = tokenizer
        self.datasource = datasource

        if not self.__initialized:
            data_path = self.__prepare_corpus_data()
            logger.info('load word2vec model: start')
            self.model = KeyedVectors.load_word2vec_format(data_path, binary=True)
            logger.info('load word2vec model: end')
            self.wmd_similarities = {}
            self.__initialized = True
        if self.__bot_id() not in self.wmd_similarities:
            self.__build_wmd_similarity()

        self.datasource = datasource

    def fit(self, x, y):
        self.__build_wmd_similarity()

    def predict(self, question_features):
        logger.info('first step word2vec wmd')

        # Note: ratingsテーブルから類似questionを検索する
        bot_ratings_data = self.datasource.ratings.by_bot(self.__bot_id())
        if len(bot_ratings_data) == 0:
            return self.__no_data()

        # NOTE: 形態素解析結果がスペース区切りの文字列になっていると、複数inputの類似検索が出来ないため一旦インデックス0を指定している
        result = self.wmd_similarities[self.__bot_id()]['ratings'][question_features[0]]

        indices = [x[0] for x in result]
        df = bot_ratings_data.iloc[indices].copy()
        df = df[['question', 'question_answer_id']]
        df['probability'] = [x[1] for x in result]

        # Note: 算出したquestionをキーにして評価の多いratingsを取得する
        top_probability = df['probability'].values[0]
        if len(df) == 0 or top_probability < self.FIRST_STEP_THRESHOLD:
            return self.__no_data()
        logger.debug(df)

        most_similar_question = df['question'].values[0]
        higher_ratings = self.datasource.ratings.higher_rate_by_bot_question(self.__bot_id(), most_similar_question)
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
        logger.info('second step word2vec wmd')
        logger.debug(data_frame)
        tokenized_questions = None

        if len(data_frame) == 0:
            # Note: ratingが付いた類似解答が見つからなかった場合は通常のWord2vec WMDを行う
            logger.info('tokenize question')
            tokenized_questions = self.tokenizer.tokenize([question])
        else:
            # Note: question_answer_idを付与して検索を行う
            logger.info('tokenize question with question_answer_id')
            top_rating_id = data_frame['question_answer_id'].values[0]
            top_rating_level = data_frame['level'].values[0]
            logger.debug('rating level:{} ({}:good, {}:bad)'.format(top_rating_level, Constants.RATING_GOOD, Constants.RATING_BAD))
            if top_rating_level == Constants.RATING_GOOD:
                tokenized_questions = self._tokenize_with_qaid([question], [str(top_rating_id)])
            else:
                tokenized_questions = self._tokenize_with_qaid([question], [self.BAD_QA_ID])
        logger.debug(tokenized_questions)

        result = self.wmd_similarities[self.__bot_id()]['question_answers'][tokenized_questions]

        bot_question_answers_data = self.datasource.question_answers.by_bot(self.__bot_id())
        indices = [x[0] for x in result]
        df = bot_question_answers_data.iloc[indices].copy()
        df = df[['question', 'question_answer_id']]
        df['probability'] = [x[1] for x in result]
        return df

    @property
    def dump_key(self):
        return 'two_steps_word2vec_wmd'

    def _tokenize_with_qaid(self, texts, question_ids):
        tokenized_sentences = self.tokenizer.tokenize(texts)
        question_id_array = np.array(['MYOPE_QA_ID:' + str(x) for x in question_ids], dtype=str).reshape(len(question_ids), 1)
        tokenized_sentences = [list(a) + list(b) for (a, b) in zip(tokenized_sentences, question_id_array)]
        return tokenized_sentences

    def __no_data(self):
        return pd.DataFrame({
            'question': [],
            'question_answer_id': [],
            'level': [],
            'probability': [],
        })

    def __bot_id(self):
        return AppStatus().current_bot().id

    def __build_wmd_similarity(self):
        bot_ratings_data = self.datasource.ratings.by_bot(self.__bot_id())
        rating_tokenized_sentences = self.tokenizer.tokenize(bot_ratings_data['question'])
        bot_question_answers_data = self.datasource.question_answers.by_bot(self.__bot_id())
        qa_tokenized_sentences = self._tokenize_with_qaid(bot_question_answers_data['question'], bot_question_answers_data['question_answer_id'].astype(int))
        self.wmd_similarities[self.__bot_id()] = {
            'ratings': WmdSimilarity(rating_tokenized_sentences, self.model, num_best=10),
            'question_answers': WmdSimilarity(qa_tokenized_sentences, self.model, num_best=10),
        }

    def __prepare_corpus_data(self):
        # TODO: word2vec_wmdと重複している
        tarfile_path = 'dumps/entity_vector.model.tar.bz2'
        model_path = 'dumps/entity_vector.model.bin'
        import os
        if not os.path.exists(model_path):
            import urllib.request
            logger.info('downloading word2vec model')
            urllib.request.urlretrieve('https://s3-ap-northeast-1.amazonaws.com/my-ope.net/datasets/entity_vector.tar.bz2', tarfile_path)
            logger.info('extracting word2vec model')
            import tarfile
            tar = tarfile.open(tarfile_path, 'r:bz2')
            tar.extractall('dumps')
            logger.info('You got word2vec model')

        return model_path

