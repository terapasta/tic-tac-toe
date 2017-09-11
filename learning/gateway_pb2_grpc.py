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
    self.Reply = channel.unary_unary(
        '/gateway.Bot/Reply',
        request_serializer=gateway__pb2.ReplyRequest.SerializeToString,
        response_deserializer=gateway__pb2.ReplyResponse.FromString,
        )


class BotServicer(object):
  # missing associated documentation comment in .proto file
  pass

  def Reply(self, request, context):
    # missing associated documentation comment in .proto file
    pass
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')


def add_BotServicer_to_server(servicer, server):
  rpc_method_handlers = {
      'Reply': grpc.unary_unary_rpc_method_handler(
          servicer.Reply,
          request_deserializer=gateway__pb2.ReplyRequest.FromString,
          response_serializer=gateway__pb2.ReplyResponse.SerializeToString,
      ),
  }
  generic_handler = grpc.method_handlers_generic_handler(
      'gateway.Bot', rpc_method_handlers)
  server.add_generic_rpc_handlers((generic_handler,))
