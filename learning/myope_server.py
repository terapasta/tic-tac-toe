import traceback
import numpy as np
import argparse
from gevent.server import StreamServer
from mprpc import RPCServer

from learning.core.stop_watch import stop_watch
from learning.log import logger
from learning.core.learn.learning_parameter import LearningParameter
from app.shared.config import Config
from app.shared.current_bot import CurrentBot
from app.controllers.reply_controller import ReplyController
from app.controllers.learn_controller import LearnController


class MyopeServer(RPCServer):

    def reply(self, bot_id, body, learning_parameter_attributes):
        CurrentBot().init(bot_id)
        # TODO: learning_parameterを使用する
        learning_parameter = LearningParameter(learning_parameter_attributes)
        X = np.array([body])

        try:
            result = ReplyController().perform(X[0])
        except:
            logger.error(traceback.format_exc())
            result = {
                'question_feature_count': 0,
                'results': [],
            }

        return result

    @stop_watch
    def learn(self, bot_id, learning_parameter_attributes):
        CurrentBot().init(bot_id)
        learning_parameter = LearningParameter(learning_parameter_attributes)
        try:
            result = LearnController().perform()
        except:
            logger.error(traceback.format_exc())
            result = {
                'accuracy': 0,
                'precision': 0,
                'recall': 0,
                'f1': 0,
            }
        return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--host', type=str, default='127.0.0.1')
    parser.add_argument('--port', type=int, default=6000)
    parser.add_argument('--env', type=str, default='development')
    args = parser.parse_args()
    Config().init(args.env)
    server = StreamServer((args.host, args.port), MyopeServer())
    server.serve_forever()
