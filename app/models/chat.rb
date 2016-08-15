class Chat < ActiveRecord::Base
  has_many :messages
  has_many :contact_states
  belongs_to :bot
  enum context: { normal: 'normal', contact: 'contact' }

  def build_start_message
    answer = bot.start_answer
    Message.new(speaker: 'bot', answer_id: answer.id, body: answer.body)
  end
end
