import traceback
import inject
import numpy as np
import argparse
from gevent.server import StreamServer
from mprpc import RPCServer

from app.shared.logger import logger
from app.shared.config import Config
from app.shared.stop_watch import stop_watch
from app.shared.current_bot import CurrentBot
from app.controllers.reply_controller import ReplyController
from app.controllers.learn_controller import LearnController
from app.factories.factory_selector import FactorySelector


class MyopeServer(RPCServer):
    def reply(self, bot_id, body, learning_parameter_attributes):
        logger.debug('bot_id = %s' % bot_id)
        logger.debug('body = %s' % body)
        logger.debug('learning_parameter = %s' % learning_parameter_attributes)
        CurrentBot().init(bot_id, learning_parameter_attributes)
        X = np.array([body])

        try:
            result = ReplyController(factory=FactorySelector().get_factory()).perform(X[0])
        except:
            logger.error(traceback.format_exc())
            result = {
                'question_feature_count': 0,
                'results': [],
            }

        return result

    @stop_watch
    def learn(self, bot_id, learning_parameter_attributes):
        CurrentBot().init(bot_id, learning_parameter_attributes)

        try:
            result = LearnController(factory=FactorySelector().get_factory()).perform()
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
    inject.configure()
    parser = argparse.ArgumentParser()
    parser.add_argument('--host', type=str, default='127.0.0.1')
    parser.add_argument('--port', type=int, default=6000)
    parser.add_argument('--env', type=str, default='development')
    args = parser.parse_args()
    Config().init(args.env)
    server = StreamServer((args.host, args.port), MyopeServer())
    server.serve_forever()
