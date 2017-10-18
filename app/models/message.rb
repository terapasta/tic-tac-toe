class Message < ActiveRecord::Base
  include AnswerMarkable
  paginates_per 50

  attr_accessor :similar_question_answers

  belongs_to :chat
  belongs_to :question_answer
  has_one :rating
  belongs_to :decision_branch

  enum speaker: { bot: 'bot', guest: 'guest' }

  serialize :similar_question_answers_log

  scope :answer_failed, -> {
    where(answer_failed: true)
  }

  scope :good, -> {
    joins(:rating).merge(Rating.good)
  }

  scope :bad, -> {
    joins(:rating).merge(Rating.bad)
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
    build_rating if rating.blank?
    rating.assign_attributes(
      level: level,
      question_answer_id: question_answer_id,
      bot_id: chat.bot.id,
      question: Message.find_pair_message_from(self).body,
      answer: body,
    )
    rating.save!
  end
end
