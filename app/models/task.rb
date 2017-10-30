class Task < ApplicationRecord
  belongs_to :bot

  scope :with_done, -> (flag) {
    where(is_done: flag.to_bool)
  }

  scope :unstarted, -> (bot) {
    where(bot_id: bot.id, is_done: false)
  }
end
