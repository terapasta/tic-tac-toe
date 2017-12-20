require 'learning/gateway_pb'
require 'learning/gateway_services_pb'

class Ml::Engine
  class NotTrainedError < StandardError; end

  def initialize(bot)
    host = ENV.fetch('RPC_HOST'){ '127.0.0.1' }
    port = ENV.fetch('RPC_PORT'){ 6000 }
    @bot = bot
    @stub = Gateway::Bot::Stub.new("#{host}:#{port}", :this_channel_is_insecure)
  end

  def reply(body)
    return @stub.reply(
      Gateway::ReplyRequest.new(
        bot_id: @bot.id,
        body: body,
        learning_parameter: Gateway::LearningParameter.new(@bot.learning_parameter_attributes),
      )).as_json.with_indifferent_access
  rescue GRPC::Unavailable => e
    log_error(e)
    raise NotTrainedError
  rescue => e
    log_error(e)
    raise e
  end

  def learn
    return @stub.learn(
      Gateway::LearnRequest.new(
        bot_id: @bot.id,
        learning_parameter: Gateway::LearningParameter.new(@bot.learning_parameter_attributes),
      )).as_json.with_indifferent_access
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
end
