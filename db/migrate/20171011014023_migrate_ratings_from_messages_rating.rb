class MigrateRatingsFromMessagesRating < ActiveRecord::Migration

  # Note: migration用にアソシエーションなどを排除したモデルを用意する
  class MessageForMigration < ActiveRecord::Base
    self.table_name = :messages
    belongs_to :chat
  end

  def up
    ActiveRecord::Base.transaction do
      Rating.delete_all
      MessageForMigration.where.not(rating: 0).find_each do |message|
        pair = Message.find_pair_message_from(Message.find(message.id))
        next if pair.nil?
        Rating.create!(
          level: message.rating,
          message_id: message.id,
          question_answer_id: message.question_answer_id,
          bot_id: message.chat.bot_id,
          question: pair.body,
          answer: message.body,
        )
      end
    end

    remove_column :messages, :rating
  end

  def down
    add_column :messages, :rating, :integer, default: 0
    add_index :messages, :rating

    Rating.find_each do |rating|
      ActiveRecord::Base.transaction do
        message = Message.find(rating.message_id)
        message.rating = rating.level
        message.save!
      end
    end
  end
end
