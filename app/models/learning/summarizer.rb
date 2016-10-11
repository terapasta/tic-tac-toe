class Learning::Summarizer
  def initialize(bot)
    @bot = bot
  end

  def summary
    LearningTrainingMessage.destroy_all(bot: @bot)
    Learning::TrainingMessageConverter.new(@bot).convert
    convert_imported_training_messages
  end

  def convert_imported_training_messages
    learning_training_messages = []
    @bot.imported_training_messages.find_each do |imported_training_message|
      learning_training_message = @bot.learning_training_messages.find_or_initialize_by(
        question: imported_training_message.question,
        answer_id: imported_training_message.answer_id
      )
      learning_training_message.answer_body = imported_training_message.answer.body
      learning_training_messages << learning_training_message
    end
    LearningTrainingMessage.import(learning_training_messages)
  end
end
