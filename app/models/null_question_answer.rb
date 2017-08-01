class NullQuestionAnswer
  attr_accessor :answer

  def initialize(bot)
    @bot = bot
    @answer = bot.classify_failed_message.presence || DefinedAnswer.classify_failed_text
  end

  def id
    QuestionAnswer::NO_CLASSIFIED_ID
  end

  def no_classified?
    true
  end
end
