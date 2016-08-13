class Ml::Engine

  def initialize(bot_id)
    @client = MessagePack::RPC::Client.new('127.0.0.1', 6000)
    @bot_id = bot_id
  end

  def reply(context, body)
    return @client.call(:reply, @bot_id, context, body)
  end

  def helpdesk_reply(body)
    return @client.call(:helpdesk_reply, @bot_id, body)
  end

  def learn
    test_scores_mean = @client.call(:learn, @bot_id)
    return test_scores_mean
  end
end
