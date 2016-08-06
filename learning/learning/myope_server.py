# -*- coding: utf-8 -
import logging
from gevent.server import StreamServer
from mprpc import RPCServer
from sklearn.externals import joblib
from .core.predict.reply import Reply
from .core.learn.bot import Bot

class MyopeServer(RPCServer):

    # f.g.
    #   context: [0, 1, 3, 1]
    #   body: 'こんにちは'
    def reply(self, context, body):
        # logging.basicConfig(filename="example.log",level=logging.DEBUG)
        # logging.debug('hogehoge')
        X = list(context)
        #X.append(body.encode('utf-8'))
        X.append(body)
        result = Reply().predict([X])  # TODO 引数
        # logging.debug(result)
        return result

    def learn(self):
        logging.basicConfig(filename="example.log",level=logging.DEBUG)
        logging.debug('MyopeServer.learn start')
        test_scores_mean = Bot().learn()
        return test_scores_mean

server = StreamServer(('127.0.0.1', 6000), MyopeServer())
server.serve_forever()
