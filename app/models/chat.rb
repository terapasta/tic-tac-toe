class Chat < ActiveRecord::Base
  include ContextHoldable
  paginates_per 50

  has_many :messages
  has_many :contact_states
  belongs_to :bot
  enum context: ContextHoldable::CONTEXTS

  scope :has_multiple_messages, -> {
    joins(:messages)
      .group('chats.id')
      .having('count(chat_id) > 1')
      .order('chats.id desc')
  }

  def build_start_message
    body = bot.start_message.presence || DefinedAnswer.start_answer_unsetting.body
    Message.new(speaker: 'bot', answer_id: nil, body: body)
  end

  def has_answer_failed_message?
    messages.any? { |m| m.answer_failed? }
  end
end
