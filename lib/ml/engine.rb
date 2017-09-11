require 'learning/gateway_pb'
require 'learning/gateway_services_pb'

class Ml::Engine

  def initialize(bot)
    @host = ENV.fetch('RPC_HOST'){ '127.0.0.1' }
    @port = 6000
    # @session_pool = MessagePack::RPC::SessionPool.new
    # @client = @session_pool.get_session(host, port)
    # @client.timeout = 30.minutes
    @bot = bot
  end

  def reply(body)
    stub = Gateway::Bot::Stub.new("#{@host}:#{@port}", :this_channel_is_insecure)
    return stub.reply(
      Gateway::ReplyRequest.new(
        bot_id: @bot.id,
        body: body,
        learning_parameter: Gateway::LearningParameter.new(@bot.learning_parameter_attributes),
      ))
  end

  def learn
    # TODO RPCサーバ側でタイムアウトしてしまうため、結果を非同期で受け取りたい
    @client.call(:learn, @bot.id, @bot.learning_parameter_attributes)
  end

  # TODO 非同期でコールバックを実行するメソッドを実装したい(RPCサーバのタイムアウト対策)、RPCサーバを変更する必要があるかも
  # def async_learn
  #   future = @client.callback(:learn, @bot.id, @bot.learning_parameter_attributes) do
  #     Rails.logger.debug('hogehogehogehogehogehogehogehogehogehogehogehoge')
  #   end
  #   future.get
  # end

  def predict_tags(bodies)
    @client.call(:predict_tags, bodies)
  end

  def learn_tag_model
    @client.call(:learn_tag_model)
  end
end
