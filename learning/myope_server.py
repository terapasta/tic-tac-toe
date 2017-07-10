import numpy as np
import time
import argparse
from gevent.server import StreamServer
from mprpc import RPCServer
from sklearn.externals import joblib

from learning.core.predict.similarity import Similarity
from learning.core.stop_watch import stop_watch
from learning.log import logger
from learning.core.predict.reply import Reply
from learning.core.predict.null_reply_result import NullReplyResult
from learning.core.predict.model_not_exists_error import ModelNotExistsError
from learning.core.learn.bot import Bot
from learning.core.learn.learning_parameter import LearningParameter
from learning.config.config import Config

class MyopeServer(RPCServer):
    STATUS_CODE_SUCCESS = 1
    STATUS_CODE_MODEL_NOT_EXISTS = 101

    def reply(self, bot_id, body, learning_parameter_attributes):
        learning_parameter = LearningParameter(learning_parameter_attributes)
        X = np.array([body])

        try:
            # HACK: similarityを利用する場合learning_parameterを使わないので、
            #       RPCサーバーの口から分けてしまったほうがスッキリする
            if learning_parameter.use_similarity_classification:
                Bot(bot_id, learning_parameter).vectorize()
                reply_result = Similarity(bot_id).make_response(X)
            else:
                reply_result = Reply(bot_id, learning_parameter).perform(X)

            status_code = self.STATUS_CODE_SUCCESS
        except ModelNotExistsError:
            reply_result = NullReplyResult()
            status_code = self.STATUS_CODE_MODEL_NOT_EXISTS

        result = {
            'status_code': status_code,
            'question': reply_result.question,
            'question_feature_count': reply_result.question_feature_count,
            'answer_id': reply_result.answer_id,
            'probability': reply_result.probability,
            'results': reply_result.to_dict(),
        }
        return result

    @stop_watch
    def learn(self, bot_id, learning_parameter_attributes):
        learning_parameter = LearningParameter(learning_parameter_attributes)
        evaluator = Bot(bot_id, learning_parameter).learn()
        return {
            'accuracy': evaluator.accuracy,
            'precision': evaluator.precision,
            'recall': evaluator.recall,
            'f1': evaluator.f1,
        }


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--host', type=str, default='127.0.0.1')
    parser.add_argument('--port', type=int, default=6000)
    parser.add_argument('--env', type=str, default='development')
    args = parser.parse_args()
    Config._ENV = args.env
    server = StreamServer((args.host, args.port), MyopeServer())
    server.serve_forever()
