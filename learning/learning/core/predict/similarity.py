import pandas as pd
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
        self.__manipulate("question_answers", question, datasource_type, 'id')
        return self

    def learning_training_messages(self, question, datasource_type='database', for_suggest=True):
        """質問文間でコサイン類似度を算出して、近い質問文の候補を取得する
        """
        self.__manipulate("learning_training_messages", question, datasource_type, 'question_answer_id', for_suggest)
        return self

    def to_data_frame(self):
        df = pd.DataFrame.from_dict(self.ordered_data).drop_duplicates(subset=[self.use_column])
        return df[self.use_column], df['similarity'], df['learning_training_message_id']

    def to_data(self):
        filter_iter = lambda x: x['similarity'] > 0.1
        filtered_data = list(filter(filter_iter, self.ordered_data))
        return filtered_data[0:10]

    def __manipulate(self, data_type, question, datasource_type, use_column, for_suggest=True):
        method_name = data_type + "_for_suggest" if for_suggest else data_type
        datasource = Datasource(type=datasource_type)

        method = getattr(datasource, method_name)
        if for_suggest:
            data = method(self._bot_id, question)
        else:
            data = method(self._bot_id)

        if data.empty:
            self.ordered_data = []
            self.use_column = use_column
            return

        similarities = self.__get_similarities(data, question)
        self.ordered_data = self.__order_result(data, similarities, use_column)

    def __get_similarities(self, data, question):
        text_array = TextArray(self.vectorizer)
        all_vec = text_array.to_vec(data['question'])
        question_vec = text_array.to_vec([question])
        similarities = cosine_similarity(all_vec, question_vec)
        similarities = similarities.flatten()
        logger.debug("similarities: %s" % similarities)
        return similarities

    def __order_result(self, data, similarities, use_column):
        logger.debug("__order_result: \n%s" % data)
        # NOTE to_data_frameで使うのでインスタンス変数にしておく
        self.use_column = use_column
        zipped_data = zip(data[self.use_column], similarities, data['id'])
        sorted_data = sorted(zipped_data, key=lambda x: x[1], reverse=True)
        map_iter = (lambda x: {
            self.use_column: float(x[0]),
            'similarity': x[1],
            'learning_training_message_id': x[2],
        })
        ordered_data = list(map(map_iter, sorted_data))
        return ordered_data
