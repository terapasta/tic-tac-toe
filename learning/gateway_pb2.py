# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: gateway.proto

import sys
_b=sys.version_info[0]<3 and (lambda x:x) or (lambda x:x.encode('latin1'))
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()




DESCRIPTOR = _descriptor.FileDescriptor(
  name='gateway.proto',
  package='gateway',
  syntax='proto3',
  serialized_pb=_b('\n\rgateway.proto\x12\x07gateway\"&\n\x11LearningParameter\x12\x11\n\talgorithm\x18\x02 \x01(\x05\"K\n\x06Result\x12\x1a\n\x12question_answer_id\x18\x01 \x01(\x05\x12\x13\n\x0bprobability\x18\x02 \x01(\x02\x12\x10\n\x08question\x18\x03 \x01(\t\"d\n\x0cReplyRequest\x12\x0e\n\x06\x62ot_id\x18\x01 \x01(\x05\x12\x0c\n\x04\x62ody\x18\x02 \x01(\t\x12\x36\n\x12learning_parameter\x18\x03 \x01(\x0b\x32\x1a.gateway.LearningParameter\"y\n\rReplyResponse\x12\x1e\n\x16question_feature_count\x18\x01 \x01(\x05\x12 \n\x07results\x18\x02 \x03(\x0b\x32\x0f.gateway.Result\x12\x12\n\nnoun_count\x18\x03 \x01(\x05\x12\x12\n\nverb_count\x18\x04 \x01(\x05\"V\n\x0cLearnRequest\x12\x0e\n\x06\x62ot_id\x18\x01 \x01(\x05\x12\x36\n\x12learning_parameter\x18\x03 \x01(\x0b\x32\x1a.gateway.LearningParameter\"P\n\rLearnResponse\x12\x10\n\x08\x61\x63\x63uracy\x18\x02 \x01(\x02\x12\x11\n\tprecision\x18\x03 \x01(\x02\x12\x0e\n\x06recall\x18\x04 \x01(\x02\x12\n\n\x02\x66\x31\x18\x05 \x01(\x02\x32y\n\x03\x42ot\x12\x38\n\x05Reply\x12\x15.gateway.ReplyRequest\x1a\x16.gateway.ReplyResponse\"\x00\x12\x38\n\x05Learn\x12\x15.gateway.LearnRequest\x1a\x16.gateway.LearnResponse\"\x00\x62\x06proto3')
)




_LEARNINGPARAMETER = _descriptor.Descriptor(
  name='LearningParameter',
  full_name='gateway.LearningParameter',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='algorithm', full_name='gateway.LearningParameter.algorithm', index=0,
      number=2, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=26,
  serialized_end=64,
)


_RESULT = _descriptor.Descriptor(
  name='Result',
  full_name='gateway.Result',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='question_answer_id', full_name='gateway.Result.question_answer_id', index=0,
      number=1, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='probability', full_name='gateway.Result.probability', index=1,
      number=2, type=2, cpp_type=6, label=1,
      has_default_value=False, default_value=float(0),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='question', full_name='gateway.Result.question', index=2,
      number=3, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=66,
  serialized_end=141,
)


_REPLYREQUEST = _descriptor.Descriptor(
  name='ReplyRequest',
  full_name='gateway.ReplyRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='bot_id', full_name='gateway.ReplyRequest.bot_id', index=0,
      number=1, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='body', full_name='gateway.ReplyRequest.body', index=1,
      number=2, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='learning_parameter', full_name='gateway.ReplyRequest.learning_parameter', index=2,
      number=3, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=143,
  serialized_end=243,
)


_REPLYRESPONSE = _descriptor.Descriptor(
  name='ReplyResponse',
  full_name='gateway.ReplyResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='question_feature_count', full_name='gateway.ReplyResponse.question_feature_count', index=0,
      number=1, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='results', full_name='gateway.ReplyResponse.results', index=1,
      number=2, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='noun_count', full_name='gateway.ReplyResponse.noun_count', index=2,
      number=3, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='verb_count', full_name='gateway.ReplyResponse.verb_count', index=3,
      number=4, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=245,
  serialized_end=366,
)


_LEARNREQUEST = _descriptor.Descriptor(
  name='LearnRequest',
  full_name='gateway.LearnRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='bot_id', full_name='gateway.LearnRequest.bot_id', index=0,
      number=1, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='learning_parameter', full_name='gateway.LearnRequest.learning_parameter', index=1,
      number=3, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=368,
  serialized_end=454,
)


_LEARNRESPONSE = _descriptor.Descriptor(
  name='LearnResponse',
  full_name='gateway.LearnResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='accuracy', full_name='gateway.LearnResponse.accuracy', index=0,
      number=2, type=2, cpp_type=6, label=1,
      has_default_value=False, default_value=float(0),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='precision', full_name='gateway.LearnResponse.precision', index=1,
      number=3, type=2, cpp_type=6, label=1,
      has_default_value=False, default_value=float(0),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='recall', full_name='gateway.LearnResponse.recall', index=2,
      number=4, type=2, cpp_type=6, label=1,
      has_default_value=False, default_value=float(0),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='f1', full_name='gateway.LearnResponse.f1', index=3,
      number=5, type=2, cpp_type=6, label=1,
      has_default_value=False, default_value=float(0),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=456,
  serialized_end=536,
)

_REPLYREQUEST.fields_by_name['learning_parameter'].message_type = _LEARNINGPARAMETER
_REPLYRESPONSE.fields_by_name['results'].message_type = _RESULT
_LEARNREQUEST.fields_by_name['learning_parameter'].message_type = _LEARNINGPARAMETER
DESCRIPTOR.message_types_by_name['LearningParameter'] = _LEARNINGPARAMETER
DESCRIPTOR.message_types_by_name['Result'] = _RESULT
DESCRIPTOR.message_types_by_name['ReplyRequest'] = _REPLYREQUEST
DESCRIPTOR.message_types_by_name['ReplyResponse'] = _REPLYRESPONSE
DESCRIPTOR.message_types_by_name['LearnRequest'] = _LEARNREQUEST
DESCRIPTOR.message_types_by_name['LearnResponse'] = _LEARNRESPONSE
_sym_db.RegisterFileDescriptor(DESCRIPTOR)

LearningParameter = _reflection.GeneratedProtocolMessageType('LearningParameter', (_message.Message,), dict(
  DESCRIPTOR = _LEARNINGPARAMETER,
  __module__ = 'gateway_pb2'
  # @@protoc_insertion_point(class_scope:gateway.LearningParameter)
  ))
_sym_db.RegisterMessage(LearningParameter)

Result = _reflection.GeneratedProtocolMessageType('Result', (_message.Message,), dict(
  DESCRIPTOR = _RESULT,
  __module__ = 'gateway_pb2'
  # @@protoc_insertion_point(class_scope:gateway.Result)
  ))
_sym_db.RegisterMessage(Result)

ReplyRequest = _reflection.GeneratedProtocolMessageType('ReplyRequest', (_message.Message,), dict(
  DESCRIPTOR = _REPLYREQUEST,
  __module__ = 'gateway_pb2'
  # @@protoc_insertion_point(class_scope:gateway.ReplyRequest)
  ))
_sym_db.RegisterMessage(ReplyRequest)

ReplyResponse = _reflection.GeneratedProtocolMessageType('ReplyResponse', (_message.Message,), dict(
  DESCRIPTOR = _REPLYRESPONSE,
  __module__ = 'gateway_pb2'
  # @@protoc_insertion_point(class_scope:gateway.ReplyResponse)
  ))
_sym_db.RegisterMessage(ReplyResponse)

LearnRequest = _reflection.GeneratedProtocolMessageType('LearnRequest', (_message.Message,), dict(
  DESCRIPTOR = _LEARNREQUEST,
  __module__ = 'gateway_pb2'
  # @@protoc_insertion_point(class_scope:gateway.LearnRequest)
  ))
_sym_db.RegisterMessage(LearnRequest)

LearnResponse = _reflection.GeneratedProtocolMessageType('LearnResponse', (_message.Message,), dict(
  DESCRIPTOR = _LEARNRESPONSE,
  __module__ = 'gateway_pb2'
  # @@protoc_insertion_point(class_scope:gateway.LearnResponse)
  ))
_sym_db.RegisterMessage(LearnResponse)



_BOT = _descriptor.ServiceDescriptor(
  name='Bot',
  full_name='gateway.Bot',
  file=DESCRIPTOR,
  index=0,
  options=None,
  serialized_start=538,
  serialized_end=659,
  methods=[
  _descriptor.MethodDescriptor(
    name='Reply',
    full_name='gateway.Bot.Reply',
    index=0,
    containing_service=None,
    input_type=_REPLYREQUEST,
    output_type=_REPLYRESPONSE,
    options=None,
  ),
  _descriptor.MethodDescriptor(
    name='Learn',
    full_name='gateway.Bot.Learn',
    index=1,
    containing_service=None,
    input_type=_LEARNREQUEST,
    output_type=_LEARNRESPONSE,
    options=None,
  ),
])
_sym_db.RegisterServiceDescriptor(_BOT)

DESCRIPTOR.services_by_name['Bot'] = _BOT

try:
  # THESE ELEMENTS WILL BE DEPRECATED.
  # Please use the generated *_pb2_grpc.py files instead.
  import grpc
  from grpc.beta import implementations as beta_implementations
  from grpc.beta import interfaces as beta_interfaces
  from grpc.framework.common import cardinality
  from grpc.framework.interfaces.face import utilities as face_utilities


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
          request_serializer=ReplyRequest.SerializeToString,
          response_deserializer=ReplyResponse.FromString,
          )
      self.Learn = channel.unary_unary(
          '/gateway.Bot/Learn',
          request_serializer=LearnRequest.SerializeToString,
          response_deserializer=LearnResponse.FromString,
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

    def Learn(self, request, context):
      # missing associated documentation comment in .proto file
      pass
      context.set_code(grpc.StatusCode.UNIMPLEMENTED)
      context.set_details('Method not implemented!')
      raise NotImplementedError('Method not implemented!')


  def add_BotServicer_to_server(servicer, server):
    rpc_method_handlers = {
        'Reply': grpc.unary_unary_rpc_method_handler(
            servicer.Reply,
            request_deserializer=ReplyRequest.FromString,
            response_serializer=ReplyResponse.SerializeToString,
        ),
        'Learn': grpc.unary_unary_rpc_method_handler(
            servicer.Learn,
            request_deserializer=LearnRequest.FromString,
            response_serializer=LearnResponse.SerializeToString,
        ),
    }
    generic_handler = grpc.method_handlers_generic_handler(
        'gateway.Bot', rpc_method_handlers)
    server.add_generic_rpc_handlers((generic_handler,))


  class BetaBotServicer(object):
    """The Beta API is deprecated for 0.15.0 and later.

    It is recommended to use the GA API (classes and functions in this
    file not marked beta) for all further purposes. This class was generated
    only to ease transition from grpcio<0.15.0 to grpcio>=0.15.0."""
    # missing associated documentation comment in .proto file
    pass
    def Reply(self, request, context):
      # missing associated documentation comment in .proto file
      pass
      context.code(beta_interfaces.StatusCode.UNIMPLEMENTED)
    def Learn(self, request, context):
      # missing associated documentation comment in .proto file
      pass
      context.code(beta_interfaces.StatusCode.UNIMPLEMENTED)


  class BetaBotStub(object):
    """The Beta API is deprecated for 0.15.0 and later.

    It is recommended to use the GA API (classes and functions in this
    file not marked beta) for all further purposes. This class was generated
    only to ease transition from grpcio<0.15.0 to grpcio>=0.15.0."""
    # missing associated documentation comment in .proto file
    pass
    def Reply(self, request, timeout, metadata=None, with_call=False, protocol_options=None):
      # missing associated documentation comment in .proto file
      pass
      raise NotImplementedError()
    Reply.future = None
    def Learn(self, request, timeout, metadata=None, with_call=False, protocol_options=None):
      # missing associated documentation comment in .proto file
      pass
      raise NotImplementedError()
    Learn.future = None


  def beta_create_Bot_server(servicer, pool=None, pool_size=None, default_timeout=None, maximum_timeout=None):
    """The Beta API is deprecated for 0.15.0 and later.

    It is recommended to use the GA API (classes and functions in this
    file not marked beta) for all further purposes. This function was
    generated only to ease transition from grpcio<0.15.0 to grpcio>=0.15.0"""
    request_deserializers = {
      ('gateway.Bot', 'Learn'): LearnRequest.FromString,
      ('gateway.Bot', 'Reply'): ReplyRequest.FromString,
    }
    response_serializers = {
      ('gateway.Bot', 'Learn'): LearnResponse.SerializeToString,
      ('gateway.Bot', 'Reply'): ReplyResponse.SerializeToString,
    }
    method_implementations = {
      ('gateway.Bot', 'Learn'): face_utilities.unary_unary_inline(servicer.Learn),
      ('gateway.Bot', 'Reply'): face_utilities.unary_unary_inline(servicer.Reply),
    }
    server_options = beta_implementations.server_options(request_deserializers=request_deserializers, response_serializers=response_serializers, thread_pool=pool, thread_pool_size=pool_size, default_timeout=default_timeout, maximum_timeout=maximum_timeout)
    return beta_implementations.server(method_implementations, options=server_options)


  def beta_create_Bot_stub(channel, host=None, metadata_transformer=None, pool=None, pool_size=None):
    """The Beta API is deprecated for 0.15.0 and later.

    It is recommended to use the GA API (classes and functions in this
    file not marked beta) for all further purposes. This function was
    generated only to ease transition from grpcio<0.15.0 to grpcio>=0.15.0"""
    request_serializers = {
      ('gateway.Bot', 'Learn'): LearnRequest.SerializeToString,
      ('gateway.Bot', 'Reply'): ReplyRequest.SerializeToString,
    }
    response_deserializers = {
      ('gateway.Bot', 'Learn'): LearnResponse.FromString,
      ('gateway.Bot', 'Reply'): ReplyResponse.FromString,
    }
    cardinalities = {
      'Learn': cardinality.Cardinality.UNARY_UNARY,
      'Reply': cardinality.Cardinality.UNARY_UNARY,
    }
    stub_options = beta_implementations.stub_options(host=host, metadata_transformer=metadata_transformer, request_serializers=request_serializers, response_deserializers=response_deserializers, thread_pool=pool, thread_pool_size=pool_size)
    return beta_implementations.dynamic_stub(channel, 'gateway.Bot', cardinalities, options=stub_options)
except ImportError:
  pass
# @@protoc_insertion_point(module_scope)
