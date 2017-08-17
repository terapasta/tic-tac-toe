import numpy as np
import pandas as pd
from app.factories.cosine_similarity_factory import CosineSimilarityFactory
from learning.core.predict.reply_result import ReplyResult


class ReplyController:
    def __init__(self, bot_id, factory=None):
        self.bot_id = bot_id
        self._factory = factory if factory is not None else CosineSimilarityFactory()

    def perform(self, text):
        bot_learning_training_messages_data = self._factory.get_learning_training_messages().by_bot(self.bot_id)
        bot_tokenized_sentences = self._factory.get_tokenizer().tokenize(bot_learning_training_messages_data['question'])
        self._factory.get_vectorizer().fit(bot_tokenized_sentences)
        bot_features = self._factory.get_vectorizer().transform(bot_tokenized_sentences)

        tokenized_sentences = self._factory.get_tokenizer().tokenize([text])
        question_features = self._factory.get_vectorizer().transform(tokenized_sentences)

        probabilities = self._factory.get_estimator().predict(question_features, bot_features)

        sorted_data = sorted(
                zip(bot_learning_training_messages_data['question_answer_id'], probabilities),
                key=lambda x: x[1],
                reverse=True
            )
        results = list(map(
                (lambda x: {
                    'question_answer_id': float(x[0]),
                    'probability': x[1],
                }),
                sorted_data
            ))

        return {
            'question_feature_count': np.count_nonzero(question_features.toarray()),
            'results': results[:10],
        }
