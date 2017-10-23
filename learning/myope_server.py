from concurrent import futures
import time

import grpc

from app.shared.word2vec import Word2vec
from gateway_pb2 import ReplyResponse, Result, LearnResponse
from gateway_pb2_grpc import BotServicer
from gateway_pb2_grpc import add_BotServicer_to_server

import traceback
import inject
import numpy as np
import argparse

from app.shared.logger import logger
from app.shared.config import Config
from app.shared.stop_watch import stop_watch
from app.shared.app_status import AppStatus
from app.shared.datasource.datasource import Datasource
from app.shared.constants import Constants
from app.controllers.reply_controller import ReplyController
from app.controllers.learn_controller import LearnController
from app.factories.factory_selector import FactorySelector


_ONE_DAY_IN_SECONDS = 60 * 60 * 24


class RouteGuideServicer(BotServicer):
    def Reply(self, request, context):
        logger.debug('request = %s' % request)
        app_status = AppStatus().set_bot(request.bot_id, request.learning_parameter)
        X = np.array([request.body])

        try:
            reply = ReplyController(factory=FactorySelector().get_factory()).perform(X[0])
        except:
            logger.error(traceback.format_exc())
            reply = {
                'question_feature_count': 0,
                'results': [],
                'noun_count': 0,
                'verb_count': 0,
            }
            context.set_details("Error")
            context.set_code(grpc.StatusCode.INTERNAL)

        app_status.thread_clear()
        return ReplyResponse(
            question_feature_count=reply['question_feature_count'],
            results=[Result(**x) for x in reply['results']],
            noun_count=reply['noun_count'],
            verb_count=reply['verb_count'],
        )

    @stop_watch
    def Learn(self, request, context):
        logger.debug('request = %s' % request)
        app_status = AppStatus().set_bot(request.bot_id, request.learning_parameter)

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
            context.set_details("Error")
            context.set_code(grpc.StatusCode.INTERNAL)

        app_status.thread_clear()
        return LearnResponse(**result)


def serve(port):
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    add_BotServicer_to_server(
            RouteGuideServicer(), server)
    server.add_insecure_port('[::]:%s' % port)
    server.start()
    try:
        while True:
            time.sleep(_ONE_DAY_IN_SECONDS)
    except KeyboardInterrupt:
        server.stop(0)


if __name__ == '__main__':
    inject.configure_once()
    parser = argparse.ArgumentParser()
    parser.add_argument('--port', type=int, default=6000)
    parser.add_argument('--env', type=str, default='development')
    parser.add_argument('--datasource_type', type=str, default=Constants.DATASOURCE_TYPE_DATABASE)
    args = parser.parse_args()
    Config().init(args.env)
    Datasource().init(datasource_type=args.datasource_type)
    Word2vec().init()

    serve(args.port)
