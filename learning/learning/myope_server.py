# -*- coding: utf-8 -
import logging
from gevent.server import StreamServer
from mprpc import RPCServer
from sklearn.externals import joblib
from core.predict.reply import Reply

class MyopeServer(RPCServer):

    # f.g.
    #   context: [0, 1, 3, 1]
    #   body: 'こんにちは'
    def reply(self, context, body):
        # logging.basicConfig(filename="example.log",level=logging.DEBUG)
        # logging.debug('hogehoge')
        X = list(context)
        X.append(body.encode('utf-8'))
        result = Reply().predict([X])  # TODO 引数
        # logging.debug(result)
        return result[0]

server = StreamServer(('127.0.0.1', 6000), MyopeServer())
server.serve_forever()
