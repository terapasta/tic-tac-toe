class Task < ApplicationRecord
  belongs_to :bot

  belongs_to :bot_message_record,
    required: false,
    foreign_key: :bot_message_id,
    class_name: 'Message'

  belongs_to :guest_message_record,
    required: false,
    foreign_key: :guest_message_id,
    class_name: 'Message'

  scope :with_done, -> (flag) {
    where(is_done: flag.to_bool)
  }

  scope :unstarted, -> (bot) {
    where(bot_id: bot.id, is_done: false)
  }
end
