require 'learning/gateway_pb'
require 'learning/gateway_services_pb'

class Ml::Engine
  class NotTrainedError < StandardError; end

  attr_reader :stub

  def initialize(bot)
    host = ENV.fetch('RPC_HOST'){ '127.0.0.1' }
    port = ENV.fetch('RPC_PORT'){ 6000 }
    @bot = bot
    @stub = Gateway::Bot::Stub.new("#{host}:#{port}", :this_channel_is_insecure)
  end

  # for only word2vec
  def setup
    setup_request = Gateway::SetupRequest.new
    @stub.setup(setup_request)
  rescue => e
    log_error(e)
  end

  def replies(bodies)
    requests = bodies.map{ |body| make_reply_request(body) }
    reply_requests = Gateway::ReplyRequests.new(data: requests)
    request(:replies, reply_requests)
  end

  def reply(body)
    reply_request = make_reply_request(body)
    request(:reply, reply_request)
  end

  def request(method_name, arg)
    return @stub.send(method_name, arg).as_json.with_indifferent_access
  rescue GRPC::Unavailable => e
    log_error(e)
    raise NotTrainedError
  rescue => e
    log_error(e)
    raise e
  end

  def learn
    learn_request = Gateway::LearnRequest.new(
      bot_id: @bot.id,
      learning_parameter: Gateway::LearningParameter.new(@bot.learning_parameter_attributes),
    )
    return @stub.learn(learn_request).as_json.with_indifferent_access
  rescue => e
    log_error(e)
    raise e
  end

  def predict_tags(bodies)
    @client.call(:predict_tags, bodies)
  end

  private
    def log_error(e)
      ExceptionNotifier.notify_exception e
      Rollbar.log(e) if defined?(Rollbar)
      logger.error 'Refer python-application.log' if respond_to?(:logger)
    end

    def make_reply_request(body)
      Gateway::ReplyRequest.new(
        bot_id: @bot.id,
        body: body,
        learning_parameter: Gateway::LearningParameter.new(@bot.learning_parameter_attributes),
      )
    end
end
