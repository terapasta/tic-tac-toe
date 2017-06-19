class Message < ActiveRecord::Base
  include AnswerMarkable
  paginates_per 50

  attr_accessor :similar_question_answers

  belongs_to :chat
  belongs_to :answer

  enum speaker: { bot: 'bot', guest: 'guest' }
  enum rating: [:nothing, :good, :bad]

  scope :answer_failed, -> {
    where(answer_failed: true)
  }

  validates :body, length: { maximum: 10000 }

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
      question_answer.answer.tap do |a|
        assign_attributes(body: a.body, answer_id: a.id)
      end
    elsif guest?
      assign_attributes(body: question_answer.question)
    end
    assign_attributes(
      rating: :nothing,
      trained_at: Time.current,
    )
    save!
  end

  def self.find_pair_message_bodies_from(message)
    messages = message.chat.messages.order(created_at: :asc)
    index = messages.find_index messages.find(message.id)
    begin
      case message.speaker
      when 'bot'
        [messages[index - 1].body, message.body]
      when 'guest'
        [message.body, messages[index + 5].body]
      end
    rescue
    end
  end
end
