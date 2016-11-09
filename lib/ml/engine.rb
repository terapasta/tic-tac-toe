class Ml::Engine

  def initialize(bot_id)
    @client = MessagePack::RPC::Client.new('127.0.0.1', 20000)
    @bot_id = bot_id
  end

  def reply(context, body)
    # binding.pry
    return @client.call(:reply, @bot_id, context, body)
  end

  def learn
    @client.call(:learn, @bot_id)
  end
end
