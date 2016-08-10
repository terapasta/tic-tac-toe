class Ml::Engine

  def initialize
    @client = MessagePack::RPC::Client.new('127.0.0.1', 6000)
  end

  def reply(context, body)
    # TODO リファクタリング中につき一旦固定値を返す
    #return @client.call(:reply, context, body)
    return 2
  end

  def learn
    test_scores_mean = @client.call(:learn)
    return test_scores_mean
  end
end
