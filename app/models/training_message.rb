class TrainingMessage < ActiveRecord::Base
  include ContextHoldable

  belongs_to :training
  belongs_to :answer
  enum speaker: { bot: 'bot', guest: 'guest' }
  enum context: ContextHoldable::CONTEXTS

  def parent
    training
  end

  # TODO リファクタリング(訓練セット用のテーブルなどを用意したほうがいいかも)
  def self.to_csv(bot)
    CSV.generate do |csv|
      arr = []
      bot.trainings.each do |training|
        guest_body, bot_body = ''
        training.training_messages.each do |training_message|
          if training_message.guest?
            guest_body = training_message.body
          elsif training_message.bot?
            bot_body = training_message.body
            if guest_body.present?
              flag = arr.each_with_index do |row, idx|
                if row[0] == guest_body
                  row = [guest_body, bot_body]
                  arr[idx] = row
                  break false
                end
              end
              arr << [guest_body, bot_body] if flag
            end
          end
        end
      end
      arr.each {|row| csv << row }
    end.encode(Encoding::SJIS)
  end
end
