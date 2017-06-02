class Learning::Converter
  def initialize(bot)
    @bot = bot
  end

  def unify_words
    word_mappings = WordMapping.for_user(@bot.user).decorate
    @bot.learning_training_messages.each do |it|
      it.question = word_mappings.replace_synonym(it.question)
    end
    self
  end

  def save
    save!
  rescue => e
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")
    false
  end

  def save!
    ActiveRecord::Base.transaction do
      @bot.learning_training_messages.each(&:save!)
    end
    true
  end
end
