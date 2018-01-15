from concurrent import futures
import signal
import sys
import time
import grpc

from gateway_pb2 import ReplyResponse, ReplyResponses, Result, LearnResponse, SetupResponse
from gateway_pb2_grpc import BotServicer
from gateway_pb2_grpc import add_BotServicer_to_server

import traceback
import argparse

from app.shared.logger import logger
from app.shared.config import Config
from app.shared.stop_watch import stop_watch
from app.shared.context import Context
from app.shared.custom_errors import NotTrainedError
from app.controllers.setup_controller import SetupController
from app.controllers.reply_controller import ReplyController
from app.controllers.learn_controller import LearnController


_ONE_DAY_IN_SECONDS = 60 * 60 * 24


class RouteGuideServicer(BotServicer):
    def Replies(self, requests, context):
        results = []
        for request in requests.data:
            results.append(self.Reply(request, context))
        return ReplyResponses(data=results)

    def Reply(self, request, context):
        logger.debug('bot_id = %s' % request.bot_id)
        logger.debug('body = %s' % request.body)
        logger.debug('learning_parameter = %s' % request.learning_parameter)
        myope_context = Context.new(
            bot_id=request.bot_id,
            learning_parameter=request.learning_parameter,
            grpc_context=context
        )

        try:
            reply = ReplyController.new(context=myope_context).perform(request.body)
        except NotTrainedError:
            detail = 'bot_id:%s wasn\'t trained' % str(myope_context.current_bot.id)
            logger.error(detail)
            logger.error(traceback.format_exc())
            reply = self._empty_reply()
            context.set_code(grpc.StatusCode.UNAVAILABLE)
            context.set_details(detail)
        except:
            logger.error(traceback.format_exc())
            reply = self._empty_reply()
            context.set_code(grpc.StatusCode.INTERNAL)
            context.set_details(traceback.format_exc())

        return ReplyResponse(
            question_feature_count=reply['question_feature_count'],
            results=[Result(**x) for x in reply['results']],
            noun_count=reply['noun_count'],
            verb_count=reply['verb_count'],
            algorithm=myope_context.current_bot.algorithm,
            feedback_algorithm=myope_context.current_bot.feedback_algorithm,
        )

    @stop_watch
    def Learn(self, request, context):
        logger.debug('request = %s' % request)
        myope_context = Context.new(
            bot_id=request.bot_id,
            learning_parameter=request.learning_parameter,
            grpc_context=context
        )

        try:
            result = LearnController.new(context=myope_context).perform()
        except:
            logger.error(traceback.format_exc())
            result = {
                'accuracy': 0,
                'precision': 0,
                'recall': 0,
                'f1': 0,
            }
            context.set_code(grpc.StatusCode.INTERNAL)
            context.set_details(traceback.format_exc())

        return LearnResponse(**result)

    def Setup(self, request, context):
        SetupController.new().perform()
        return SetupResponse()

    def _empty_reply(self):
        return {
            'question_feature_count': 0,
            'results': [],
            'noun_count': 0,
            'verb_count': 0,
        }


def serve(port):
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    add_BotServicer_to_server(
            RouteGuideServicer(), server)
    server.add_insecure_port('[::]:%s' % port)
    server.start()
    logger.info('server running!!')
    try:
        while True:
            time.sleep(_ONE_DAY_IN_SECONDS)
    except KeyboardInterrupt:
        server.stop(0)


def on_sigsegv(signum, frame):
    logger.error('signal segmentation fault!!!')
    logger.error(signum)
    logger.error(traceback.format_stack(frame))
    sys.exit()


def on_abort(signum, frame):
    logger.error('signal abort!!!')
    logger.error(signum)
    logger.error(traceback.format_stack(frame))
    sys.exit()


if __name__ == '__main__':
    logger.info('server starting...')
    parser = argparse.ArgumentParser()
    parser.add_argument('--port', type=int, default=6000)
    parser.add_argument('--env', type=str, default='development')
    args = parser.parse_args()
    Config().init(args.env)

    signal.signal(signal.SIGSEGV, on_sigsegv)
    signal.signal(signal.SIGABRT, on_sigsegv)

    serve(args.port)
