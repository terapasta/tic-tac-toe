class NullAnswer
  def initialize(bot)
    @bot = bot
  end

  def id
    nil
  end

  def context
    nil
  end

  def body
    DefinedAnswer.classify_failed.body
  end

  def no_classified?
    true
  end
end
