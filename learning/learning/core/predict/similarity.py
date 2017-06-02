from sklearn.metrics.pairwise import cosine_similarity
from learning.core.datasource import Datasource
from learning.core.persistance import Persistance
from learning.core.predict.model_not_exists_error import ModelNotExistsError
from learning.core.training_set.text_array import TextArray
from learning.log import logger


class Similarity:
    def __init__(self, bot_id):
        self._bot_id = bot_id

        try:
            self.vectorizer = Persistance.load_vectorizer(bot_id)
        except IOError:
            raise ModelNotExistsError()


    def question_answers(self, question, datasource_type='database'):
        """質問文間でコサイン類似度を算出して、近い質問文の候補を取得する
        """
        return self.__manipulate("question_answers", question, datasource_type, 'id')

    def learning_training_messages(self, question, datasource_type='database'):
        """質問文間でコサイン類似度を算出して、近い質問文の候補を取得する
        """
        return self.__manipulate("learning_training_messages", question, datasource_type, 'question_answer_id')

    def __manipulate(self, data_type, question, datasource_type, use_column):
        method_name = "%s_for_suggest" % data_type
        datasource = Datasource(type=datasource_type)
        data = getattr(datasource, method_name)(self._bot_id, question)
        similarities = self.__get_similarities(data, question)
        ordered_result = self.__order_result(data, similarities, use_column)
        return ordered_result[0:10]

    def __get_similarities(self, data, question):
        all_array = TextArray(data['question'], vectorizer=self.vectorizer)
        all_vec = all_array.to_vec()
        question_array = TextArray([question], vectorizer=self.vectorizer)
        question_vec = question_array.to_vec()
        similarities = cosine_similarity(all_vec, question_vec)
        similarities = similarities.flatten()
        logger.debug("similarities: %s" % similarities)
        return similarities

    def __order_result(self, data, similarities, use_column):
        logger.debug("__order_result: \n%s" % data)
        zipped_data = zip(data[use_column], similarities)
        sorted_data = sorted(zipped_data, key=lambda x: x[1], reverse=True)
        map_iter = lambda x: { use_column: float(x[0]), 'similarity': x[1] }
        ordered_data = list(map(map_iter, sorted_data))
        filtered_data = list(filter((lambda x: x['similarity'] > 0.1), ordered_data))
        return filtered_data
