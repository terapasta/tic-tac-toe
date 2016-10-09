class TrainingMessage < ActiveRecord::Base
  include ContextHoldable

  belongs_to :training
  belongs_to :answer
  enum speaker: { bot: 'bot', guest: 'guest' }
  enum context: ContextHoldable::CONTEXTS

  def parent
    training
  end

  def self.to_csv(bot)
    CSV.generate do |csv|
      bot.trainings.each do |training|
        guest_body, bot_body = ''
        training.training_messages.each do |training_message|
          # binding.pry
          # binding.pry
          if training_message.guest?
            guest_body = training_message.body
          elsif training_message.bot?
            bot_body = training_message.body
            csv << [guest_body, bot_body] if guest_body.present?
          end
        end
      end
    end.encode(Encoding::SJIS)
  end
end
