class NullAnswer
  attr_accessor :body

  def initialize(bot)
    @bot = bot
    @body = bot.classify_failed_message.presence || DefinedAnswer.classify_failed.body
  end

  def id
    nil
  end

  def context
    nil
  end

  def no_classified?
    true
  end
end
