import numpy as np
from gevent.server import StreamServer
from mprpc import RPCServer
from sklearn.externals import joblib

from learning.core.predict.similarity import Similarity
from learning.log import logger
from learning.core.predict.reply import Reply
from learning.core.predict.null_reply_result import NullReplyResult
from learning.core.predict.model_not_exists_error import ModelNotExistsError
from learning.core.learn.bot import Bot
from learning.core.learn.tag import Tag as LearnTag
from learning.core.predict.tag import Tag as PredictTag
from learning.core.learn.learning_parameter import LearningParameter

class MyopeServer(RPCServer):
    STATUS_CODE_SUCCESS = 1
    STATUS_CODE_MODEL_NOT_EXISTS = 101

    def reply(self, bot_id, body, learning_parameter_attributes):
        learning_parameter = LearningParameter(learning_parameter_attributes)
        X = np.array([body])
        status_code = self.STATUS_CODE_SUCCESS
        reply_result = NullReplyResult()

        try:
            reply_result = Reply(bot_id, learning_parameter).perform(X)
        except ModelNotExistsError:
            status_code = self.STATUS_CODE_MODEL_NOT_EXISTS

        result = {
            'status_code': status_code,
            'results': reply_result.to_dict(),
        }
        return result
        # return { 'status_code': status_code, 'answer_id': answer_id }

    def learn(self, bot_id, learning_parameter_attributes):
        learning_parameter = LearningParameter(learning_parameter_attributes)
        evaluator = Bot(bot_id, learning_parameter).learn()
        return {
            'accuracy': evaluator.accuracy,
            'precision': evaluator.precision,
            'recall': evaluator.recall,
            'f1': evaluator.f1,
        }

    def similarity(self, bot_id, question):
        result = Similarity(bot_id).question_answers(question)
        return result

    def learn_tag_model(self):
        LearnTag().learn()
        return { 'status_code': self.STATUS_CODE_SUCCESS }

    def predict_tags(self, bodies):
        result = PredictTag().predict(bodies)
        logger.debug("result.__class__.__name__: %s" % result.__class__.__name__)
        return {
            'status_code': self.STATUS_CODE_SUCCESS,
            # 'tags': result.tolist()
            'tags': result
        }


if __name__ == '__main__':
    server = StreamServer(('127.0.0.1', 6000), MyopeServer())
    server.serve_forever()
