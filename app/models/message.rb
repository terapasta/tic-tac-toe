class Message < ActiveRecord::Base
  belongs_to :chat
  belongs_to :answer
  enum speaker: { bot: 'bot', guest: 'guest' }
  enum context: { normal: 'normal', contact: 'contact' }

  def parent
    chat
  end
end
