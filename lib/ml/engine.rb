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
    param = @bot.learning_parameter_attributes.slice(:include_failed_data)  # TODO キーを選択する処理はmodelに寄せたい
    @client.call(:learn, @bot.id, param)
  end
end
