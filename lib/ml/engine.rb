class Ml::Engine

  def initialize(bot)
    @client = MessagePack::RPC::Client.new('127.0.0.1', 6000)
    @client.timeout = 20
    @bot = bot
  end

  def reply(context, body)
    return @client.call(:reply, @bot.id, context, body)
  end

  def learn
    @client.call(:learn, @bot.id, @bot.learning_parameter_attributes)
  end

  def predict_tags(bodies)
    @client.call(:predict_tags, bodies)
  end

  def learn_tag_model
    @client.call(:learn_tag_model)
  end
end
