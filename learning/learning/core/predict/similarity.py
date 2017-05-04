from sklearn.metrics.pairwise import cosine_similarity
from learning.core.datasource import Datasource
from learning.core.persistance import Persistance
from learning.core.predict.model_not_exists_error import ModelNotExistsError
from learning.core.training_set.text_array import TextArray
from learning.log import logger


class Similarity:
    def __init__(self, bot_id):
        self._datasource = Datasource()
        self._bot_id = bot_id
        try:
            self.vectorizer = Persistance.load_vectorizer(bot_id)
        except IOError:
            raise ModelNotExistsError()


    def question_answers(self, question):
        """質問文間でコサイン類似度を算出して、近い質問文の候補を取得する
        """
        question_answers = self._datasource.question_answers_for_suggest(self._bot_id, question)
        all_array = TextArray(question_answers['question'], vectorizer=self.vectorizer)
        question_array = TextArray([question], vectorizer=self.vectorizer)

        similarities = cosine_similarity(all_array.to_vec(), question_array.to_vec())
        similarities = similarities.flatten()
        logger.debug("similarities: %s" % similarities)

        ordered_result = list(map(lambda x: {
            'question_answer_id': float(x[0]), 'similarity': x[1]
        }, sorted(zip(question_answers['id'], similarities), key=lambda x: x[1], reverse=True)))

        ordered_result = list(filter((lambda x: x['similarity'] > 0.1), ordered_result))

        return ordered_result[0:10]