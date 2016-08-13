# -*- coding: utf-8 -
import logging
from gevent.server import StreamServer
from mprpc import RPCServer
from sklearn.externals import joblib
from core.predict.reply import Reply
from core.predict.helpdesk_classify import HelpdeskClassify
from core.predict.model_not_exists_error import ModelNotExistsError
from core.learn.bot import Bot

class MyopeServer(RPCServer):
    STATUS_CODE_SUCCESS = 1
    STATUS_CODE_MODEL_NOT_EXISTS = 101

    # f.g.
    #   context: [0, 1, 3, 1]
    #   body: 'こんにちは'
    def reply(self, bot_id, context, body):
        # logging.basicConfig(filename="example.log",level=logging.DEBUG)
        # logging.debug('hogehoge')
        X = list(context)
        #X.append(body.encode('utf-8'))
        X.append(body)
        answer_id = None
        status_code = self.STATUS_CODE_SUCCESS

        try:
            answer_id = Reply(bot_id).predict([X])  # TODO 引数
        except ModelNotExistsError:
            status_code = self.STATUS_CODE_MODEL_NOT_EXISTS

        return { 'status_code': status_code, 'answer_id': answer_id }

    def helpdesk_reply(self, bot_id, body):
        print('hogehoge')
        X = []
        X.append(body)
        help_answer_id = None
        status_code = self.STATUS_CODE_SUCCESS

        try:
            help_answer_id = HelpdeskClassify(bot_id).predict([X])  # TODO 引数を配列ではなく文字列単体にしたい
            print(help_answer_id)
        except ModelNotExistsError:
            status_code = self.STATUS_CODE_MODEL_NOT_EXISTS

        return { 'status_code': status_code, 'help_answer_id': float(help_answer_id) }


    def learn(self, bot_id):
        logging.basicConfig(filename="example.log",level=logging.DEBUG)
        logging.debug('MyopeServer.learn start')
        test_scores_mean = Bot(bot_id).learn()
        return test_scores_mean

server = StreamServer(('127.0.0.1', 6000), MyopeServer())
server.serve_forever()
