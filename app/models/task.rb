class Task < ActiveRecord::Base
  belongs_to :bot

  scope :with_done, -> (flag) {
    where(is_done: flag.to_bool)
  }

  scope :unstarted, -> (bot) {
    where(bot_id: bot.id, is_done: false)
  }

  def build_new_record(bot_id, chat, message_id, is_bad:)
    self.bot_id = bot_id
    # bad評価もしくは回答失敗した、guestとbotのメッセージを取得する
    messages = chat.messages.select{ |message, i| message.id == message_id || message.id == message_id + 1 }
      if is_bad == "bad"
        self.guest_message = messages[0].body
        self.bot_message   = messages[1].body
      else
        self.guest_message = messages[0].body
      end
  end
end
