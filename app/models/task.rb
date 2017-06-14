class Task < ActiveRecord::Base
  belongs_to :bot

  scope :is_done, -> (flag) {
    where(is_done: flag.to_bool)
  }

  scope :unstarted, -> (bot) {
    where(bot_id: bot.id, is_done: false)
  }

  def set_task(task, bot_id, chat, message_id, action)
    task.bot_id = bot_id
    chat.messages.each_with_index do |message, i|
      if message.id == message_id
        if action == "bad"
          task.guest_message = chat.messages[i - 1].body
          task.bot_message   = message.body
        else
          task.guest_message =  message.body
        end
      end
      task.save
    end
  end
end
