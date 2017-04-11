import MySQLdb
import numpy as np

from learning.core.predict.model_not_exists_error import ModelNotExistsError
from learning.core.predict.reply_result import ReplyResult
from learning.config.config import Config
from learning.core.persistance import Persistance
from learning.core.training_set.text_array import TextArray
from learning.log import logger


class Reply:
    CLASSIFY_FAILED_ANSWER_ID = 0

    def __init__(self, bot_id, learning_parameter):
        config = Config()
        dbconfig = config.get('database')
        self.db = MySQLdb.connect(host=dbconfig['host'], db=dbconfig['name'], user=dbconfig['user'],
                             passwd=dbconfig['password'], charset='utf8')
        self.bot_id = bot_id
        self.learning_parameter = learning_parameter
        self.answers = []
        self.probabilities = []

        try:
            self.estimator = Persistance.load_model(bot_id)
            self.vectorizer = Persistance.load_vectorizer(bot_id)
        except IOError:
            raise ModelNotExistsError()

    def perform(self, X):
        text_array = TextArray(X, vectorizer=self.vectorizer)
        logger.debug('Reply#perform text_array.separated_sentences: %s' % text_array.separated_sentences)
        features = text_array.to_vec()
        logger.debug('Reply#perform features: %s' % features)
        count = np.count_nonzero(features.toarray())

        # タグベクトルを追加する処理
        # if self.learning_parameter.include_tag_vector:
        #     tag = Tag()
        #     tag_vec = tag.predict(Xtrain, return_type='binarized')
        #     features = np.c_[tag_vec, Xtrain_vec]

        # self.answers = self.estimator.predict(features)
        self.probabilities = self.estimator.predict_proba(features)
        self.answer_ids = self.estimator.classes_

        reply_result = ReplyResult(self.answer_ids, self.probabilities, X[0], count)
        reply_result.out_log_of_results()
        return reply_result