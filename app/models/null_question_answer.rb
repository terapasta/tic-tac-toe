class NullQuestionAnswer
  attr_accessor :answer

  def initialize(bot)
    @bot = bot
    @answer = bot.classify_failed_message.presence || DefinedAnswer.classify_failed.body
  end

  def id
    0
  end

  def no_classified?
    true
  end
end
