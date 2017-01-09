class Learning::TrainingMessageConverter
  include Learning::TagSummarizable

  def initialize(bot)
    @bot = bot
  end

  def convert!
    qa = {}
    @bot.trainings.find_each do |training|
      guest_body, bot_body = ''
      tag_ids = []
      training.training_messages.where(learn_enabled: true).each do |training_message|
        if training_message.guest?
          guest_body = training_message.body
          tag_ids = training_message.tags.pluck(:id).join(':')
        elsif training_message.bot?
          if guest_body.present? && training_message_hold?(training_message)
            qa[guest_body] = {
              answer_id: training_message.answer_id,
              body: training_message.body,
              tag_ids: tag_ids
            }
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
        LearningTrainingMessage.new(
          bot: @bot,
          question: key,
          answer_body: value[:body],
          answer_id: value[:answer_id],
          tag_ids: value[:tag_ids]
        )
      end
      # merge_tag_ids!(learning_training_messages)
      LearningTrainingMessage.import!(learning_training_messages)
    end

    def training_message_hold?(training_message)
      # training_message.answer.present? && training_message.answer.type.nil?
      training_message.answer.present?
    end
end
