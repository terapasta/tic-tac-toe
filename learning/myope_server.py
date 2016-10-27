from gevent.server import StreamServer
from mprpc import RPCServer
from sklearn.externals import joblib
from learning.log import logger
from learning.core.predict.reply import Reply
from learning.core.predict.model_not_exists_error import ModelNotExistsError
from learning.core.learn.bot import Bot

class MyopeServer(RPCServer):
    STATUS_CODE_SUCCESS = 1
    STATUS_CODE_MODEL_NOT_EXISTS = 101

    # f.g.
    #   context: [0, 1, 3, 1]
    #   body: 'こんにちは'
    def reply(self, bot_id, context, body):
        X = list(context)
        #X.append(body.encode('utf-8'))
        X.append(body)
        answer_id = None
        status_code = self.STATUS_CODE_SUCCESS

        try:
            answer_id = Reply(bot_id).predict([X])  # TODO 引数
            if answer_id is not None:
                answer_id = float(answer_id)
        except ModelNotExistsError:
            status_code = self.STATUS_CODE_MODEL_NOT_EXISTS

        # result = {
        #     'status_code': status_code,
        #     'answer_ids': [1,2,3]
        # }
        # return result
        return { 'status_code': status_code, 'answer_id': answer_id }

    def learn(self, bot_id):
        evaluator = Bot(bot_id).learn()
        return {
            'accuracy': evaluator.accuracy,
            'precision': evaluator.precision,
            'recall': evaluator.recall,
            'f1': evaluator.f1,
        }

server = StreamServer(('127.0.0.1', 6000), MyopeServer())
server.serve_forever()
