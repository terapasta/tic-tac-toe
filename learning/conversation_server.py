# -*- coding: utf-8 -
from gevent.server import StreamServer
from mprpc import RPCServer
from sklearn.externals import joblib
from predicter import Predicter

class ConversationServer(RPCServer):
    def reply(self, context, body):
        X = list(context)
        X.append(body)
        svm_model = joblib.load("models/svm_model")
        vocabulary = joblib.load("vocabulary/vocabulary.pkl")

        predicter = Predicter(svm_model, vocabulary)
        return predicter.predict(context)


server = StreamServer(('127.0.0.1', 6000), ConversationServer())
server.serve_forever()
