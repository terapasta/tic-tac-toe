class Message < ActiveRecord::Base
  belongs_to :chat
  belongs_to :answer
  enum speaker: { bot: 'bot', guest: 'guest' }
  enum context: { normal: 'normal', contact: 'contact' }

  def self.start_message
    answer = Answer.find(Answer::START_MESSAGE_ID)
    Message.new(speaker: 'bot', answer_id: answer.id, body: answer.body)
  end
end
