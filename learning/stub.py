from __future__ import print_function
import grpc
import gateway_pb2


def run():
    channel = grpc.insecure_channel('localhost:50051')
    stub = gateway_pb2.AVRGatewayStub(channel)
    response = stub.Reply(gateway_pb2.ReplyRequest(bot_id=1))
    print("Greeter client received: " + response.question)


if __name__ == '__main__':
    run()
