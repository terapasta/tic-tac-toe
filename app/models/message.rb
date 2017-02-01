class Message < ActiveRecord::Base
  paginates_per 50

  attr_accessor :other_answers

  belongs_to :chat
  belongs_to :answer

  enum speaker: { bot: 'bot', guest: 'guest' }
  enum rating: [:nothing, :good, :bad]

  validates :body, length: { maximum: 10000 }

  scope :answer_failed, -> {
    where(answer_failed: true)
  }

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
end
