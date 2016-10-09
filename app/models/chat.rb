class Chat < ActiveRecord::Base
  include ContextHoldable
  paginates_per 50

  has_many :messages
  has_many :contact_states
  belongs_to :bot
  enum context: ContextHoldable::CONTEXTS

  def build_start_message
    answer = bot.start_answer
    Message.new(speaker: 'bot', answer_id: answer.id, body: answer.body)
  end
end
