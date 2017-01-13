class Ml::Engine

  def initialize(bot)
    @client = MessagePack::RPC::Client.new('127.0.0.1', 6000)
    @client.timeout = 30.minutes
    @bot = bot
  end

  # TODO 現在contextは使用されていないので削除したい
  def reply(context, body)
    return @client.call(:reply, @bot.id, context, body, @bot.learning_parameter_attributes)
  end

  def learn
    # @client.call(:learn, @bot.id, @bot.learning_parameter_attributes)
    future = @client.call_async(:learn, @bot.id, @bot.learning_parameter_attributes)
    future.get
    # future = @client.call_async(:learn, @bot.id, @bot.learning_parameter_attributes)
    # future.get
  end

  def predict_tags(bodies)
    @client.call(:predict_tags, bodies)
  end

  def learn_tag_model
    @client.call(:learn_tag_model)
  end
end
