class Message < ActiveRecord::Base
  belongs_to :chat

  enum speaker: { bot: 'bot', guest: 'guest' }
end
