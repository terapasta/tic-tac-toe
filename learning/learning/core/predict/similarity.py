import MySQLdb
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity

from learning.config.config import Config
from learning.core.persistance import Persistance
from learning.core.predict.model_not_exists_error import ModelNotExistsError
from learning.core.training_set.text_array import TextArray
from learning.log import logger


class Similarity:
    def __init__(self, bot_id):
        config = Config()
        dbconfig = config.get('database')
        self.db = MySQLdb.connect(host=dbconfig['host'], db=dbconfig['name'], user=dbconfig['user'],
                                  passwd=dbconfig['password'], charset='utf8')
        self.bot_id = bot_id
        try:
            self.vectorizer = Persistance.load_vectorizer(bot_id)
        except IOError:
            raise ModelNotExistsError()


    def question_answers(self, question):
        """質問文間でコサイン類似度を算出して、近い質問文の候補を取得する
        """
        question_answers = self.__all_question_answers()
        all_array = TextArray(question_answers['question'], vectorizer=self.vectorizer)
        # FIXME 1件のquestionのためにTextArrayクラスを使用するのは直感的ではない
        question_array = TextArray([question], vectorizer=self.vectorizer)

        similarities = cosine_similarity(all_array.to_vec(), question_array.to_vec())
        similarities = similarities.flatten()
        logger.debug("similarities: %s" % similarities)

        ordered_result = list(map(lambda x: {
            'question_answer_id': x[0], 'similarity': x[1]
        }, sorted(zip(question_answers['id'], similarities), key=lambda x: x[1], reverse=True)))
        return ordered_result

    def __all_question_answers(self):
        data = pd.read_sql("select id, question from question_answers where bot_id = %s;" % self.bot_id, self.db)
        return data