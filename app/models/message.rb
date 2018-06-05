class Message < ApplicationRecord
  include AnswerMarkable
  paginates_per 50

  attr_accessor :similar_question_answers, :has_initial_questions

  belongs_to :chat
  belongs_to :question_answer
  has_one :rating
  accepts_nested_attributes_for :rating
  belongs_to :decision_branch
  has_many :bad_reasons
  belongs_to :guest_message,
    -> { guest },
    class_name: 'Message',
    foreign_key: :guest_message_id

  has_many :bot_messages,
    -> { bot },
    class_name: 'Message',
    foreign_key: :guest_message_id

  enum speaker: { bot: 'bot', guest: 'guest' }

  serialize :similar_question_answers_log

  after_create do
    if guest?
      chat&.bot&.tutorial&.done_ask_question_if_needed!
    end
  end

  scope :answer_failed, -> {
    where(answer_failed: true)
  }

  scope :good, -> {
    joins(:rating).merge(Rating.good)
  }

  scope :bad, -> {
    joins(:rating).merge(Rating.bad)
  }

  scope :is_staff_message, -> (flag) {
    where(chats: {is_staff: false}) if flag
  }

  scope :is_normal_message, -> (flag) {
    where(chats: {is_normal: flag})
  }

  scope :bot_message_ids, -> {
    Message.bot.select(:id)
  }

  scope :has_answer_failed_or_bad_or_good_or_marked_answer, -> (answer_failed_flag, good_flag, bad_flag, marked_flag) {
    conditions = []
    conditions << bot_message_ids.answer_failed if answer_failed_flag.present?
    conditions << bot_message_ids.good if good_flag.present?
    conditions << bot_message_ids.bad if bad_flag.present?
    conditions << bot_message_ids.answer_marked if marked_flag.present?
    query_func = -> (condition) { joins(:bot_messages).where(bot_messages_messages: { id: condition }) }
    if conditions.any?
      conditions.drop(1).inject(query_func.call(conditions[0])) { |query, it|
        query.or(query_func.call(it))
      }
    end
  }

  validates :body, length: { maximum: 10000 }

  def parent
    chat
  end

  def speaker_image_url
    if bot?
      parent.bot.image_url
    elsif guest?
      'silhouette.png'
    else
      'operator'
    end
  end

  def update_for_training_with!(question_answer)
    if bot?
      assign_attributes(body: question_answer.answer)
    elsif guest?
      assign_attributes(body: question_answer.question)
    end
    assign_attributes(answer_failed: false)
    rating&.destroy!
    save!
  end

  def good!
    make_rating!(:good)
  end

  def bad!
    make_rating!(:bad)
  end

  def no_rating!
    rating.destroy! if rating.present?
  end

  def self.find_pair_message_from(message)
    return nil if message.chat.nil?
    messages = message.chat.messages.order(created_at: :asc)
    return nil if messages.size < 2
    index = messages.find_index(message)
    case message.speaker
    when 'bot'
      messages[index - 1]
    when 'guest'
      messages[index + 1]
    end
  end

  def self.build_for_bot_test(chat)
    bot_test_results = []
    chat.messages.each_with_index do |message, i|
      next if i.odd?
      messages = []
      messages.push(message.body)
      messages.push(chat.messages[i + 1].body)
      bot_test_results.push(messages)
    end
    bot_test_results
  end

  private

  def make_rating!(level)
    attrs = {
      is_show_similar_question_answers: true,
      rating_attributes: {
        message_id: id,
        level: level,
        question_answer_id: question_answer_id,
        bot_id: chat.bot.id,
        question: Message.find_pair_message_from(self).body,
        answer: body,
      }
    }
    if rating&.persisted?
      attrs[:rating_attributes][:id] = rating.id
    end
    assign_attributes(attrs)
    save!
  end
end
