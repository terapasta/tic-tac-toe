# Generated by the gRPC Python protocol compiler plugin. DO NOT EDIT!
import grpc

import gateway_pb2 as gateway__pb2


class BotStub(object):
  # missing associated documentation comment in .proto file
  pass

  def __init__(self, channel):
    """Constructor.

    Args:
      channel: A grpc.Channel.
    """
    self.Setup = channel.unary_unary(
        '/gateway.Bot/Setup',
        request_serializer=gateway__pb2.SetupRequest.SerializeToString,
        response_deserializer=gateway__pb2.SetupResponse.FromString,
        )
    self.Reply = channel.unary_unary(
        '/gateway.Bot/Reply',
        request_serializer=gateway__pb2.ReplyRequest.SerializeToString,
        response_deserializer=gateway__pb2.ReplyResponse.FromString,
        )
    self.Learn = channel.unary_unary(
        '/gateway.Bot/Learn',
        request_serializer=gateway__pb2.LearnRequest.SerializeToString,
        response_deserializer=gateway__pb2.LearnResponse.FromString,
        )


class BotServicer(object):
  # missing associated documentation comment in .proto file
  pass

  def Setup(self, request, context):
    # missing associated documentation comment in .proto file
    pass
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def Reply(self, request, context):
    # missing associated documentation comment in .proto file
    pass
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')

  def Learn(self, request, context):
    # missing associated documentation comment in .proto file
    pass
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')


def add_BotServicer_to_server(servicer, server):
  rpc_method_handlers = {
      'Setup': grpc.unary_unary_rpc_method_handler(
          servicer.Setup,
          request_deserializer=gateway__pb2.SetupRequest.FromString,
          response_serializer=gateway__pb2.SetupResponse.SerializeToString,
      ),
      'Reply': grpc.unary_unary_rpc_method_handler(
          servicer.Reply,
          request_deserializer=gateway__pb2.ReplyRequest.FromString,
          response_serializer=gateway__pb2.ReplyResponse.SerializeToString,
      ),
      'Learn': grpc.unary_unary_rpc_method_handler(
          servicer.Learn,
          request_deserializer=gateway__pb2.LearnRequest.FromString,
          response_serializer=gateway__pb2.LearnResponse.SerializeToString,
      ),
  }
  generic_handler = grpc.method_handlers_generic_handler(
      'gateway.Bot', rpc_method_handlers)
  server.add_generic_rpc_handlers((generic_handler,))
