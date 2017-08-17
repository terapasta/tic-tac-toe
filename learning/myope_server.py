import traceback
import numpy as np
import argparse
from gevent.server import StreamServer
from mprpc import RPCServer

from learning.core.stop_watch import stop_watch
from learning.log import logger
from learning.core.predict.null_reply_result import NullReplyResult
from learning.core.learn.bot import Bot
from learning.core.learn.learning_parameter import LearningParameter
from app.shared.config import Config
from app.controllers.reply_controller import ReplyController


class MyopeServer(RPCServer):

    def reply(self, bot_id, body, learning_parameter_attributes):
        # TODO: learning_parameterを使用する
        learning_parameter = LearningParameter(learning_parameter_attributes)
        X = np.array([body])

        try:
            result = ReplyController(bot_id).perform(X[0])
        except:
            logger.error(traceback.format_exc())
            result = {
                'question_feature_count': 0,
                'results': [],
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
    Config().init(args.env)
    server = StreamServer((args.host, args.port), MyopeServer())
    server.serve_forever()
