class Message < ActiveRecord::Base
  include AnswerMarkable
  paginates_per 50

  attr_accessor :other_answers, :similar_question_answers

  belongs_to :chat
  belongs_to :answer

  after_create :send_mail

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

  def send_mail
    if bot? && answer_failed?
      AnswerFailedMailer.create(self).deliver_later
    end
  end
end
