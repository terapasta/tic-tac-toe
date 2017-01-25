import numpy as np
from gevent.server import StreamServer
from mprpc import RPCServer
from sklearn.externals import joblib
from learning.log import logger
from learning.core.predict.reply import Reply
from learning.core.predict.model_not_exists_error import ModelNotExistsError
from learning.core.learn.bot import Bot
from learning.core.learn.tag import Tag as LearnTag
from learning.core.predict.tag import Tag as PredictTag
from learning.core.learn.learning_parameter import LearningParameter

class MyopeServer(RPCServer):
    STATUS_CODE_SUCCESS = 1
    STATUS_CODE_MODEL_NOT_EXISTS = 101

    def reply(self, bot_id, body, learning_parameter_attributes):
        learning_parameter = LearningParameter(learning_parameter_attributes)
        X = np.array([body])
        predict_results = {}
        status_code = self.STATUS_CODE_SUCCESS

        try:
            # TODO 戻り値をReplyResultクラスにする
            predict_results = Reply(bot_id, learning_parameter).perform(X)
            # logger.debug(predict_results)
            # if answer_id is not None:
            #     answer_id = float(answer_id)
        except ModelNotExistsError:
            status_code = self.STATUS_CODE_MODEL_NOT_EXISTS

        # TODO 近い質問を一覧を返す
        # reply.similarity_question_answer_ids(question)

        # TODO ReplyResultクラスから出力する
        result = {
            'status_code': status_code,
            # 'results':  [{'probability': 0.99974810633704125, 'answer_id': 20}, {'probability': 4.8263524435402245e-05, 'answer_id': 2092}, {'probability': 3.8650944875454533e-06, 'answer_id': 2065}, {'probability': 3.3403655454494557e-06, 'answer_id': 2128}, {'probability': 3.2779455165232719e-06, 'answer_id': 2298}, {'probability': 3.2096909894687076e-06, 'answer_id': 57}, {'probability': 2.770086869426734e-06, 'answer_id': 2030}, {'probability': 2.4034569493278136e-06, 'answer_id': 2314}, {'probability': 2.4034569493267467e-06, 'answer_id': 2337}, {'probability': 2.3194390806239406e-06, 'answer_id': 2047}]

            'results': predict_results,
        }
        return result
        # return { 'status_code': status_code, 'answer_id': answer_id }

    def learn(self, bot_id, learning_parameter_attributes):
        learning_parameter = LearningParameter(learning_parameter_attributes)
        evaluator = Bot(bot_id, learning_parameter).learn()
        return {
            'accuracy': evaluator.accuracy,
            'precision': evaluator.precision,
            'recall': evaluator.recall,
            'f1': evaluator.f1,
        }

    def learn_tag_model(self):
        LearnTag().learn()
        return { 'status_code': self.STATUS_CODE_SUCCESS }

    def predict_tags(self, bodies):
        result = PredictTag().predict(bodies)
        logger.debug("result.__class__.__name__: %s" % result.__class__.__name__)
        return {
            'status_code': self.STATUS_CODE_SUCCESS,
            # 'tags': result.tolist()
            'tags': result
        }


if __name__ == '__main__':
    server = StreamServer(('127.0.0.1', 6000), MyopeServer())
    server.serve_forever()
