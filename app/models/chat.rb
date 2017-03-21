class Chat < ActiveRecord::Base
  include ContextHoldable
  paginates_per 50

  has_many :messages
  has_many :contact_states
  belongs_to :bot
  enum context: ContextHoldable::CONTEXTS

  scope :has_multiple_messages, -> {
    joins(:messages)
      .select('chats.*',
              "SUM(CASE WHEN speaker = 'guest' THEN 1 ELSE 0 END) as exchanging_messages_count")
      .group('chat_id')
      .having('count(chat_id) > 1')
      .order('chats.id desc')
  }

  scope :has_answer_failed, -> (flag) {
    if flag.present?
      where(id: Message.select(:chat_id).answer_failed)
    end
  }

  scope :has_good_answer, -> (flag) {
    if flag.present?
      where(id: Message.select(:chat_id).good)
    end
  }

  scope :has_bad_answer, -> (flag) {
    if flag.present?
      where(id: Message.select(:chat_id).bad)
    end
  }

  scope :not_staff, -> (flag) {
    if flag.present?
      where(is_staff: false)
    end
  }

  def build_start_message
    body = bot.start_message.presence || DefinedAnswer.start_answer_unsetting.body
    Message.new(speaker: 'bot', answer_id: nil, body: body)
  end

  def has_answer_failed_message?
    messages.any? { |m| m.answer_failed? }
  end

  def has_good_answer?
    messages.any? { |m| m.good? }
  end

  def has_bad_answer?
    messages.any? { |m| m.bad? }
  end

  class << self
    def find_by_guest_key!(guest_key)
      chat = where(guest_key: guest_key).last
      if chat.nil?
        fail ActiveRecord::RecordNotFound.new("Cannot find by guest_key: #{guest_key}")
      end
      chat
    end
  end
end
