class NullAnswer
  attr_accessor :body

  def initialize(bot)
    @bot = bot
    @body = bot.classify_failed_message.presence || DefinedAnswer.classify_failed.body
  end

  # HACK 回答なしのIDとして0を使用しているので、nilではなく0にしたい(影響調査が必要なためあとで対応)
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
