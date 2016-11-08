class Learning::TrainingMessageConverter
  def initialize(bot)
    @bot = bot
  end

  def convert!
    qa = {}
    @bot.trainings.find_each do |training|
      guest_body, bot_body = ''
      training.training_messages.each do |training_message|
        if training_message.guest?
          guest_body = training_message.body
        elsif training_message.bot?
          if guest_body.present? && training_message_hold?(training_message)
            qa[guest_body] = { answer_id: training_message.answer_id, body: training_message.body }
            guest_body = ''
          end
        end
      end
    end
    bulk_insert(qa)
  end

  private
    def bulk_insert(qa_hash)
      learning_training_messages = qa_hash.map do |key, value|
        LearningTrainingMessage.new(bot: @bot, question: key, answer_body: value[:body], answer_id: value[:answer_id])
      end
      LearningTrainingMessage.import!(learning_training_messages)
    end

    def training_message_hold?(training_message)
      # training_message.answer.present? && training_message.answer.type.nil?
      training_message.answer.present?
    end
end
