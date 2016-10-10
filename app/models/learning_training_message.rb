class LearningTrainingMessage < ActiveRecord::Base
  belongs_to :bot

  def self.to_csv(bot)
    CSV.generate do |csv|
      bot.learning_training_messages.find_each do |learning_training_message|
        csv << [
          learning_training_message.question,
          learning_training_message.answer_body,
        ]
      end
    end.encode(Encoding::SJIS)
  end
end
