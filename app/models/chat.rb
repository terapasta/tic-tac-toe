class Chat < ApplicationRecord
  paginates_per 50

  has_many :messages, -> { extending HasManyMessagesExtension }
  belongs_to :bot
  has_many :organizations, through: :bot
  has_many :users, through: :organizations
  belongs_to :guest_user, foreign_key: :guest_key, primary_key: :guest_key

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

  scope :not_normal, -> (flag) {
    if flag.present?
      where(is_normal: false)
    end
  }

  scope :normal, -> (flag) {
    if flag.present?
      where(is_normal: true)
    end
  }

  scope :has_answer_marked, -> (flag) {
    if flag.present?
      where(id: Message.select(:chat_id).answer_marked)
    end
  }

  scope :question_message, -> (chat_id, answer_message_id) {
    #回答メッセージの直近guestメッセージを質問メッセージとして扱う
    find_by(id: chat_id).messages.guest.where('id < ?', answer_message_id).order(:id).last
  }

  scope :in_today_by_unique_user, -> {
    now = Time.current
    joins(:messages)
      .where(messages: {
        speaker: :guest,
        created_at: (now.beginning_of_day..now.end_of_day)
      })
      .uniq
  }

  def build_start_message
    body = bot.start_message.presence || DefinedAnswer.start_answer_unsetting_text
    self.messages << Message.new(speaker: 'bot', body: body)
  end

  def has_answer_failed_message?
    messages.any? { |m| m.answer_failed? }
  end

  def has_good_answer?
    messages.any? { |m| m.rating&.good? }
  end

  def has_bad_answer?
    messages.any? { |m| m.rating&.bad? }
  end

  def has_answer_marked_message?
    messages.any? { |m| m.answer_marked? }
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

  def self.build_with_user_role(bot)
    chat = bot.chats.build(guest_key: SecureRandom.hex(64))
    chat.is_staff = bot.user.staff?
    chat
  end
end
