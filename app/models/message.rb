class Message < ActiveRecord::Base
  include ContextHoldable

  belongs_to :chat
  belongs_to :answer
  enum speaker: { bot: 'bot', guest: 'guest' }
  enum context: ContextHoldable::CONTEXTS

  def parent
    chat
  end

  def to_training_message_attributes
    {
      answer_id: answer_id,
      speaker: speaker,
      body: body,
    }
  end
end
