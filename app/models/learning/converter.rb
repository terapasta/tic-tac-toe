class Learning::Converter
  def initialize(bot)
    @bot = bot
  end

  def unify_words
    a = WordMapping.for_user(@bot.user).pluck(:synonym, :word)
    mappings = Hash[*a.flatten]

    @bot.learning_training_messages.each do |learning_training_message|
      q = learning_training_message.question
      mappings.each do |synonym, word|
        if q.include?(synonym)
          learning_training_message.question = q.gsub(/#{synonym}/, word)
        end
      end
    end
    self
  end

  def save
    true
  end
end
