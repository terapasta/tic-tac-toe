class Ml::Engine

  def initialize(bot_id)
    @client = MessagePack::RPC::Client.new('127.0.0.1', 6000)
    @bot_id = bot_id
  end

  def reply(context, body)
    # TODO リファクタリング中につき一旦固定値を返す
    #return @client.call(:reply, context, body)
    return 2
  end

  def learn
    test_scores_mean = @client.call(:learn, @bot_id)
    return test_scores_mean
  end
end
